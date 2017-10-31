package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Spinner;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Currency;
import com.example.janschwarz1.myapplication.models.Item;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.Ratio;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.utils.AppSettings;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;
import com.example.janschwarz1.myapplication.utils.TitleValueArrayAdapter;

import java.util.ArrayList;
import java.util.UUID;

import io.realm.RealmResults;

public class ItemActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Item.PERSON_ID";
    public static String ITEM_ID = "com.example.janschwarz1.myapplication.activities.Item.ITEM_ID";

    private Person owner;
    private Item item;
    private RealmResults<Ratio> originalRatios;
    private ArrayList<Ratio> ratios;

    private EditText nameText;
    private EditText valueText;
    private Spinner currencySpinner;
    private ListView ratioList;
    private TitleValueArrayAdapter<Ratio> ratioAdapter;
    private TitleValueAdapter<Currency> currencyAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_item);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);

        nameText = (EditText) findViewById(R.id.itemNameTextView);
        valueText = (EditText) findViewById(R.id.itemValueTextView);
        currencySpinner = (Spinner) findViewById(R.id.itemCurrencySpinner);
        ratioList = (ListView) findViewById(R.id.itemRatiosListView);

        Intent intent = getIntent();
        String itemId = intent.getStringExtra(ItemActivity.ITEM_ID);
        String personId = intent.getStringExtra(ItemActivity.PERSON_ID);

        if (itemId != null) {
            setTitle("Update item");
            item = RealmManager.shared.item(itemId);
            owner = item.getOwner();
            nameText.setText(item.getName());
            valueText.setText(item.getValueInCurrency().toString());

            ratios = new ArrayList<Ratio>();
            originalRatios = item.getRatios();
            for (Ratio r: originalRatios) {
                ratios.add(r);
            }
        } else {
            setTitle("Add item");
            owner = RealmManager.shared.person(personId);
            item = new Item();

            originalRatios = RealmManager.shared.ratiosOfItem(item);
            ratios = new ArrayList<Ratio>();
        }

        currencyAdapter = new TitleValueAdapter<Currency>(AppSettings.shared.getCurrencies(), new ItemActivityDataSource());
        currencySpinner.setAdapter(currencyAdapter);
        int defaultCurPos = 0;
        int selectedCurPos = -1;
        Currency selectedCur = item.getCurrency() == null ? AppSettings.shared.getReferenceCurrency() : item.getCurrency();
        for (int i = 0; i < currencyAdapter.getCount(); i++) {
            if (selectedCur.getCode().equals(currencyAdapter.getItem(i).getCode())) {
                selectedCurPos = i;
                break;
            }
            if (AppSettings.shared.getReferenceCurrency().getCode().equals(currencyAdapter.getItem(i).getCode())) {
                defaultCurPos = i;
            }
        }
        for (Currency c: AppSettings.shared.getCurrencies()) {
        }
        currencySpinner.setSelection(selectedCurPos >= 0 ? selectedCurPos : defaultCurPos);

        reloadConsumers();

        ratioList.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final Ratio ratio = (Ratio) ratioAdapter.getItem(position);
                presentRatioActivity(ratio);
            }
        });

        ratioList.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, final int position, long id) {
                final Ratio ratio = (Ratio) ratioAdapter.getItem(position);
                AlertDialog alertDialog = new AlertDialog.Builder(ItemActivity.this).create();
                alertDialog.setTitle("Delete consumer");
                alertDialog.setMessage("Do you really want to delete " + ratio.getDebtor().getName());
                alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Delete",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                ratios.remove(position);
                                reloadConsumers();
                                dialog.dismiss();
                            }
                        });
                alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "Cancel",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
                alertDialog.show();
                return true;
            }
        });

        setupUI(findViewById(R.id.itemParent));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        final MenuItem menuItem = menu.add(Menu.NONE, 1000, Menu.NONE, "Done");
        MenuItemCompat.setShowAsAction(menuItem, MenuItem.SHOW_AS_ACTION_IF_ROOM);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                setResult(RESULT_CANCELED);
                finish();
                return true;

            default:
                done();
                return true;
        }
    }

    public void addRatio(View view) {
        presentRatioActivity(null);
    }

    protected void presentRatioActivity(Ratio ratio) {
        Intent intent = new Intent(this, RatioActivity.class);
        if (ratio == null) {
            String ids = "";
            for (Ratio r: ratios) {
                ids += "&" + r.getDebtor().getId();
            }
            ids += "&" + owner.getId();
            ids = ids.replaceFirst("&", "");
            intent.putExtra(RatioActivity.OMIT_IDS, ids);
        } else {
            intent.putExtra(RatioActivity.RATIO_ID, ratio.getId());
        }
        startActivityForResult(intent, 0);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 0 && resultCode == RESULT_OK) {
            String id = data.getStringExtra(RatioActivity.RESULT_RATIO_ID);
            String debtorId = data.getStringExtra(RatioActivity.RESULT_DEBTOR_ID);
            Double value = data.getDoubleExtra(RatioActivity.RESULT_VALUE, 0);
            Person debtor = RealmManager.shared.person(debtorId);
            Ratio ratio = new Ratio(id, item, debtor, value);
            int index = indexOfRatio(ratio.getId());
            if (index >= 0) {
                ratios.remove(index);
                ratios.add(index, ratio);
            } else {
                ratios.add(ratio);
            }
            reloadConsumers();
        }
    }

    protected void reloadConsumers() {
        Ratio[] array = new Ratio[ratios.size()];
        ratios.toArray(array);
        ratioAdapter = new TitleValueArrayAdapter(this, array);
        ratioList.setAdapter(ratioAdapter);

        int height = 41*array.length;
        Resources r = getResources();
        float px = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, height, r.getDisplayMetrics());

        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) ratioList.getLayoutParams();
        params.height = Math.round(px);
        ratioList.setLayoutParams(params);
        ratioList.requestLayout();
    }

    protected int indexOfRatio(String id) {
        for (int i = 0; i < ratios.size(); i++) {
            if (ratios.get(i).getId().equals(id)) {
                return i;
            }
        }

        return -1;
    }

    protected void setupUI(View view) {

        // Set up touch listener for non-text box views to hide keyboard.
        if (!(view instanceof EditText)) {
            view.setOnTouchListener(new View.OnTouchListener() {
                public boolean onTouch(View v, MotionEvent event) {
                    hideSoftKeyboard();
                    return false;
                }
            });
        }

        //If a layout container, iterate over children and seed recursion.
        if (view instanceof ViewGroup) {
            for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
                View innerView = ((ViewGroup) view).getChildAt(i);
                setupUI(innerView);
            }
        }
    }

    protected void hideSoftKeyboard() {
        InputMethodManager inputMethodManager =
                (InputMethodManager) this.getSystemService(
                        this.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(
                this.getCurrentFocus().getWindowToken(), 0);
    }

    protected void done() {
        try {
            String name = nameText.getText().toString();
            Double value = Double.parseDouble(valueText.getText().toString());
            Currency c = (Currency) currencySpinner.getSelectedItem();

            if (value > 0 && c != null && name.length() > 0) {
                Item newItem = new Item(item.getId(), name, owner, value, c);
                RealmManager.shared.write(newItem);
                saveRatios(newItem);
            } else {
                throw new Exception();
            }

            setResult(RESULT_OK);
            finish();
        }
        catch (Exception ex) {
            AlertDialog alertDialog = new AlertDialog.Builder(this).create();
            alertDialog.setTitle("Invalid Input");
            alertDialog.setMessage("Cannot save invalid item");
            alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "OK",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    });
            alertDialog.show();
        }
    }

    protected void saveRatios(Item item) {
        for (Ratio r: ratios) {
            Ratio newRatio = new Ratio(r.getId(), item, r.getDebtor(), r.getRatio());
            RealmManager.shared.write(newRatio);
        }
        for (Ratio r: originalRatios) {
            int index = indexOfRatio(r.getId());
            if (index < 0) {
                RealmManager.shared.remove(r);
            }
        }
    }
}

class ItemActivityDataSource implements TitleValueAdapterDataSource<Currency> {

    ItemActivityDataSource() {
    }

    @Override
    public String getTitleForItem(Currency item) {
        return "";
    }

    @Override
    public String getValueForItem(Currency item) {
        return item.getCode();
    }
}

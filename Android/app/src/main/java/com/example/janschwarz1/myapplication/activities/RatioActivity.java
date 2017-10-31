package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ListView;
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

import java.util.ArrayList;
import java.util.UUID;

public class RatioActivity extends AppCompatActivity {

    public static String RATIO_ID = "com.example.janschwarz1.myapplication.activities.Ratio.RATIO_ID";
    public static String OMIT_IDS = "com.example.janschwarz1.myapplication.activities.Ratio.OMIT";
    public static String RESULT_RATIO_ID = "com.example.janschwarz1.myapplication.activities.Ratio.RESULT_RATIO_ID";
    public static String RESULT_DEBTOR_ID = "com.example.janschwarz1.myapplication.activities.Ratio.RESULT_DEBTOR_ID";
    public static String RESULT_VALUE = "com.example.janschwarz1.myapplication.activities.Ratio.RESULT_VALUE";

    private Spinner peopleSpinner;
    private EditText valueTextView;
    private String ratioId;
    private TitleValueAdapter<Person> peopleAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ratio);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);

        valueTextView = (EditText) findViewById(R.id.ratioValuTextView);
        peopleSpinner = (Spinner) findViewById(R.id.ratioPersonSpinner);

        Intent intent = getIntent();
        ratioId = intent.getStringExtra(RatioActivity.RATIO_ID);
        String omitIds = intent.getStringExtra(RatioActivity.OMIT_IDS);

        if (ratioId != null) {
            setTitle("Update ratio");

            Ratio ratio = RealmManager.shared.ratio(ratioId);
            peopleAdapter = new TitleValueAdapter<Person>(RealmManager.shared.peopleWith(new String[]{ratio.getDebtor().getId()}), new RatioActivityDataSource());
            valueTextView.setText(ratio.getRatio().toString());
        } else {
            setTitle("Add consumer");

            String[] ids = omitIds.split("&");
            peopleAdapter = new TitleValueAdapter<Person>(RealmManager.shared.peopleWithout(ids), new RatioActivityDataSource());
        }

        peopleSpinner.setAdapter(peopleAdapter);
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

    public void done() {
        try {
            String id = ratioId == null ? UUID.randomUUID().toString() : ratioId;
            Person p = (Person) peopleSpinner.getSelectedItem();
            Double value = Double.parseDouble(valueTextView.getText().toString());

            if (value > 0 && p != null) {
                Intent resultIntent = new Intent();
                resultIntent.putExtra(RatioActivity.RESULT_RATIO_ID, id);
                resultIntent.putExtra(RatioActivity.RESULT_DEBTOR_ID, p.getId());
                resultIntent.putExtra(RatioActivity.RESULT_VALUE, value);
                setResult(RESULT_OK, resultIntent);
            } else {
                throw new Exception();
            }

            finish();
        }
        catch (Exception ex) {
            AlertDialog alertDialog = new AlertDialog.Builder(this).create();
            alertDialog.setTitle("Invalid Input");
            alertDialog.setMessage("Cannot save invalid consumer");
            alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "OK",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    });
            alertDialog.show();
        }
    }
}

class RatioActivityDataSource implements TitleValueAdapterDataSource<Person> {

    RatioActivityDataSource() {
    }

    @Override
    public String getTitleForItem(Person item) {
        return "";
    }

    @Override
    public String getValueForItem(Person item) {
        return item.getName();
    }
}

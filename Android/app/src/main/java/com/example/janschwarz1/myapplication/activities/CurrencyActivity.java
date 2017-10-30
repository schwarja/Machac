package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.TextView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Currency;
import com.example.janschwarz1.myapplication.utils.RealmManager;

public class CurrencyActivity extends AppCompatActivity {

    public static String CURRENCY_CODE = "com.example.janschwarz1.myapplication.activities.currency.CURRENCY_CODE";

    private EditText currencyCode;
    private TextView czkValueLabel;
    private EditText czkValue;
    private EditText currencyValue;

    private Currency currency;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_currency);

        Intent intent = getIntent();
        String code = intent.getStringExtra(CurrencyActivity.CURRENCY_CODE);
        currency = RealmManager.shared.currency(code);

        currencyCode = (EditText) findViewById(R.id.currencyCodeTextView);
        czkValueLabel = (TextView) findViewById(R.id.currencyAmountCzkLabel);
        czkValue = (EditText) findViewById(R.id.currencyAmountCzkTextView);
        currencyValue = (EditText) findViewById(R.id.currencyAmountNewTextView);

        czkValueLabel.setText("Amount of " + Currency.defaultCode);

        if (currency == null) {
            setTitle("Add currency");
        } else {
            setTitle(currency.getCode());

            currencyCode.setText(currency.getCode());
            czkValue.setText(currency.getRelationToCzk().toString());
            currencyValue.setText("1");
        }
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
                finish();
                return true;

            default:
                saveCurrency();
                return true;
        }
    }

    protected void saveCurrency() {
        try {
            String code = currencyCode.getText().toString();
            Double czk = Double.parseDouble(czkValue.getText().toString());
            Double val = Double.parseDouble(currencyValue.getText().toString());

            if (code.length() > 0 && czk > 0 && val > 0) {
                Double fraction = czk / val;
                Currency currency = new Currency(code, fraction, false);
                RealmManager.shared.write(currency);
            } else {
                throw new Exception();
            }

            finish();
        }
        catch (Exception ex) {
            AlertDialog alertDialog = new AlertDialog.Builder(this).create();
            alertDialog.setTitle("Invalid Input");
            alertDialog.setMessage("Cannot save invalid currency");
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

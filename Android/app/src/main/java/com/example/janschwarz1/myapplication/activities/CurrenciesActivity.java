package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Currency;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import io.realm.RealmResults;

public class CurrenciesActivity extends AppCompatActivity {

    private ListView list;
    private TitleValueAdapter<Currency> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_currencies);
        setTitle("Currencies");

        list = (ListView) findViewById(R.id.currenciesListView);

        RealmResults<Currency> currencies = RealmManager.shared.currencies();
        adapter = new TitleValueAdapter(currencies);
        list.setAdapter(adapter);

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final Currency currency = adapter.getItem(position);

                if (currency.getCode().equals(Currency.defaultCode)) {
                    return;
                }

                Intent intent = new Intent(CurrenciesActivity.this, CurrencyActivity.class);
                intent.putExtra(CurrencyActivity.CURRENCY_CODE, currency.getCode());
                startActivity(intent);
            }
        });

        list.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                final Currency currency = adapter.getItem(position);

                if (currency.getCode().equals(Currency.defaultCode)) {
                    return false;
                }

                AlertDialog alertDialog = new AlertDialog.Builder(CurrenciesActivity.this).create();
                alertDialog.setTitle("Delete currency");
                alertDialog.setMessage("Do you really want to delete " + currency.getCode());
                alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Delete",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                RealmManager.shared.remove(currency);
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

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                finish();
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void addCurrency(View view) {
        Intent intent = new Intent(CurrenciesActivity.this, CurrencyActivity.class);
        startActivity(intent);
    }
}

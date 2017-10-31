package com.example.janschwarz1.myapplication.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Menu;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.ScrollView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.utils.AppSettings;
import com.example.janschwarz1.myapplication.utils.RealmManager;

public class MainActivity extends AppCompatActivity {

    private ProgressBar progressBar;
    private Button addItemButton;
    private Button peopleButton;
    private Button currenciesButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        progressBar = (ProgressBar) findViewById(R.id.mainProgressBar);
        addItemButton = (Button) findViewById(R.id.addItemButton);
        peopleButton = (Button) findViewById(R.id.peopleButton);
        currenciesButton = (Button) findViewById(R.id.currenciesButton);

        if (RealmManager.shared.realm != null) {
            setupActivity();
        } else {
            addItemButton.setEnabled(false);
            peopleButton.setEnabled(false);
            currenciesButton.setEnabled(false);
            RealmManager.shared.setListener(new RealmManager.ChangeListener() {

                @Override
                public void onChange() {
                    if (RealmManager.shared.realm != null) {
                        RealmManager.shared.setListener(null);
                        setupActivity();
                    }
                }
            });
        }
    }

    public void showSelectOwner(View view) {
        Intent intent = new Intent(this, SelectOwnerActivity.class);
        startActivity(intent);
    }

    public void showPeople(View view) {
        Intent intent = new Intent(this, PeopleActivity.class);
        startActivity(intent);
    }

    public void showCurrencies(View view) {
        Intent intent = new Intent(this, CurrenciesActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    protected void setupActivity() {
        AppSettings.shared.initialize();
        progressBar.setVisibility(View.GONE);
        addItemButton.setEnabled(true);
        peopleButton.setEnabled(true);
        currenciesButton.setEnabled(true);
     }
}

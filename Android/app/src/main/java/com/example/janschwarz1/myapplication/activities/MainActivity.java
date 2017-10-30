package com.example.janschwarz1.myapplication.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Menu;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.utils.AppSettings;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        AppSettings.shared.initialize();
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
}

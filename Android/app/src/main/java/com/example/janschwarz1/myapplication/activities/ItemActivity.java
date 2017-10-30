package com.example.janschwarz1.myapplication.activities;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;

import com.example.janschwarz1.myapplication.R;

public class ItemActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Item.PERSON_ID";
    public static String ITEM_ID = "com.example.janschwarz1.myapplication.activities.Item.ITEM_ID";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_item);
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
}

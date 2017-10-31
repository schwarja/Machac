package com.example.janschwarz1.myapplication.activities;

import android.content.Intent;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;

import com.example.janschwarz1.myapplication.R;

public class TextInputActivity extends AppCompatActivity {

    static public final String RESULT = "com.example.janschwarz1.myapplication.TEXT_INPUT_RESULT";

    private EditText input;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_text_input);
        setTitle("Add person");

        input = (EditText) findViewById(R.id.inputTextView);
        input.setText("");
        input.setHint("Name");
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
        int resultCode = input.getText().length() > 0 ? RESULT_OK : RESULT_CANCELED;
        Intent resultIntent = new Intent();
        resultIntent.putExtra(TextInputActivity.RESULT, input.getText().toString());
        setResult(resultCode, resultIntent);
        finish();
    }
}

package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.Spinner;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.Ratio;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import java.util.UUID;

public class SelectOwnerActivity extends AppCompatActivity {

    private Spinner peopleSpinner;
    private TitleValueAdapter<Person> peopleAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_owner);

        peopleSpinner = (Spinner) findViewById(R.id.selectOwnerSpinner);

        peopleAdapter = new TitleValueAdapter<Person>(RealmManager.shared.people(), new SelectOwnerActivityDataSource());

        peopleSpinner.setAdapter(peopleAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        final MenuItem menuItem = menu.add(Menu.NONE, 1000, Menu.NONE, "Next");
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
                next();
                return true;
        }
    }

    public void next() {
        try {
            Person p = (Person) peopleSpinner.getSelectedItem();

            if (p != null) {
                Intent intent = new Intent(this, ItemActivity.class);
                intent.putExtra(ItemActivity.PERSON_ID, p.getId());
                startActivityForResult(intent, 0);
            } else {
                throw new Exception();
            }
        }
        catch (Exception ex) {
            AlertDialog alertDialog = new AlertDialog.Builder(this).create();
            alertDialog.setTitle("Invalid Input");
            alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "OK",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    });
            alertDialog.show();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 0 && resultCode == RESULT_OK) {
            finish();
        }
    }
}

class SelectOwnerActivityDataSource implements TitleValueAdapterDataSource<Person> {

    SelectOwnerActivityDataSource() {
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

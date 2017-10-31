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
import com.example.janschwarz1.myapplication.models.Item;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import io.realm.RealmResults;

public class ItemsActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Items.ID";

    private Person person;
    private ListView list;
    private TitleValueAdapter<Item> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_items);

        Intent intent = getIntent();
        String personId = intent.getStringExtra(ItemsActivity.PERSON_ID);
        person = RealmManager.shared.person(personId);

        setTitle("Items of " + person.getName());

        list = (ListView) findViewById(R.id.itemsListView);

        adapter = new TitleValueAdapter(person.getItems());
        list.setAdapter(adapter);

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final Item item = adapter.getItem(position);
                Intent intent = new Intent(ItemsActivity.this, ItemActivity.class);
                intent.putExtra(ItemActivity.ITEM_ID, item.getId());
                startActivity(intent);
            }
        });

        list.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                final Item item = adapter.getItem(position);
                AlertDialog alertDialog = new AlertDialog.Builder(ItemsActivity.this).create();
                alertDialog.setTitle("Delete item");
                alertDialog.setMessage("Do you really want to delete " + item.getName());
                alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Delete",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                RealmManager.shared.remove(item);
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

    public void addItem(View view) {
        Intent intent = new Intent(this, ItemActivity.class);
        intent.putExtra(ItemActivity.PERSON_ID, person.getId());
        startActivity(intent);
    }

}

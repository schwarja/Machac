package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import io.realm.RealmResults;

public class PeopleActivity extends AppCompatActivity {

    private ListView list;
    private TitleValueAdapter<Person> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_people);
        setTitle("People");

        list = (ListView) findViewById(R.id.peopleListView);

        RealmResults<Person> people = RealmManager.shared.people();
        adapter = new TitleValueAdapter(people);
        list.setAdapter(adapter);

        list.setOnItemClickListener(new OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            }
        });

        list.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                final Person person = adapter.getItem(position);
                AlertDialog alertDialog = new AlertDialog.Builder(PeopleActivity.this).create();
                alertDialog.setTitle("Delete person");
                alertDialog.setMessage("Do you really want to delete " + person.getName());
                alertDialog.setButton(AlertDialog.BUTTON_NEGATIVE, "Delete",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                RealmManager.shared.remove(person);
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

    public void addPerson(View view) {
        Intent intent = new Intent(this, TextInputActivity.class);
        startActivityForResult(intent, 0);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 0 && resultCode == RESULT_OK) {
            String name = data.getStringExtra(TextInputActivity.RESULT);
            Person person = new Person(name);
            RealmManager.shared.write(person);
        }
    }
}

package com.example.janschwarz1.myapplication.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.provider.Contacts;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Item;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import java.util.ArrayList;

import io.realm.RealmResults;

public class OwesActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Owes.ID";

    private Person person;
    private ListView list;
    private TitleValueAdapter<Person> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_owes);

        Intent intent = getIntent();
        String personId = intent.getStringExtra(OwesActivity.PERSON_ID);
        person = RealmManager.shared.person(personId);

        setTitle(person.getName() + " owes");

        list = (ListView) findViewById(R.id.owesListView);

        RealmResults<Person> people = RealmManager.shared.peopleWithout(new Person[]{person});
        adapter = new TitleValueAdapter(people, new OwesActivityDataSource(person));
        list.setAdapter(adapter);

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final Person owesToPerson = adapter.getItem(position);
                Intent intent = new Intent(OwesActivity.this, DebtsActivity.class);
                intent.putExtra(DebtsActivity.PERSON_ID, person.getId());
                intent.putExtra(DebtsActivity.OWES_TO_ID, owesToPerson.getId());
                startActivity(intent);
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
}

class OwesActivityDataSource implements TitleValueAdapterDataSource<Person> {

    private Person referencePerson;

    OwesActivityDataSource(Person referencePerson) {
        this.referencePerson = referencePerson;
    }

    @Override
    public String getTitleForItem(Person item) {
        return item.getName();
    }

    @Override
    public String getValueForItem(Person item) {
        return String.format( "%.2f", referencePerson.owesTo(item));
    }
}

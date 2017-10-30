package com.example.janschwarz1.myapplication.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import io.realm.RealmResults;

public class IsOwedActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.IsOwed.ID";

    private Person person;
    private ListView list;
    private TitleValueAdapter<Person> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_is_owed);

        Intent intent = getIntent();
        String personId = intent.getStringExtra(IsOwedActivity.PERSON_ID);
        person = RealmManager.shared.person(personId);

        setTitle("Is owed to " + person.getName());

        list = (ListView) findViewById(R.id.isOwedListView);

        RealmResults<Person> people = RealmManager.shared.peopleWithout(new Person[]{person});
        adapter = new TitleValueAdapter(people, new IsOwedActivityDataSource(person));
        list.setAdapter(adapter);

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final Person owesToPerson = adapter.getItem(position);
                Intent intent = new Intent(IsOwedActivity.this, DebtsActivity.class);
                intent.putExtra(DebtsActivity.PERSON_ID, owesToPerson.getId());
                intent.putExtra(DebtsActivity.OWES_TO_ID, person.getId());
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

class IsOwedActivityDataSource implements TitleValueAdapterDataSource<Person> {

    private Person referencePerson;

    IsOwedActivityDataSource(Person referencePerson) {
        this.referencePerson = referencePerson;
    }

    @Override
    public String getTitleForItem(Person item) {
        return item.getName();
    }

    @Override
    public String getValueForItem(Person item) {
        return String.format( "%.2f", referencePerson.wantsFrom(item));
    }
}

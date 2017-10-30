package com.example.janschwarz1.myapplication.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Item;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.Ratio;
import com.example.janschwarz1.myapplication.utils.RealmManager;

import io.realm.RealmChangeListener;
import io.realm.RealmResults;

public class PersonActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Person.ID";

    private Person person;

    private Button owesButton;
    private Button isOwedButton;
    private Button itemsButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person);

        owesButton = (Button) findViewById(R.id.personOwesButton);
        isOwedButton = (Button) findViewById(R.id.personIsOwedButton);
        itemsButton = (Button) findViewById(R.id.personItemsButton);

        Intent intent = getIntent();
        String personId = intent.getStringExtra(PersonActivity.PERSON_ID);
        person = RealmManager.shared.person(personId);

        setTitle(person.getName());
        setButtons();

        person.getItems().addChangeListener(new RealmChangeListener<RealmResults<Item>>() {
            @Override
            public void onChange(RealmResults<Item> results) {
                setButtons();
            }
        });

        person.getRatios().addChangeListener(new RealmChangeListener<RealmResults<Ratio>>() {
            @Override
            public void onChange(RealmResults<Ratio> results) {
                setButtons();
            }
        });
    }

    @Override
    protected void onDestroy() {
        person.getItems().removeAllChangeListeners();

        super.onDestroy();
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

    void setButtons() {
        owesButton.setText(person.getName() + " owes (" + String.format( "%.2f", person.owes()) + ")");
        isOwedButton.setText("Is owed to " + person.getName() + " (" + String.format( "%.2f", person.isOwedTo()) + ")");
        itemsButton.setText(person.getName() + "'s items (" + person.getItems().size() + ")");
    }

    public void showOwesList(View view) {
        Intent intent = new Intent(this, OwesActivity.class);
        intent.putExtra(OwesActivity.PERSON_ID, person.getId());
        startActivity(intent);
    }

    public void showIsOwedList(View view) {
        Intent intent = new Intent(this, IsOwedActivity.class);
        intent.putExtra(IsOwedActivity.PERSON_ID, person.getId());
        startActivity(intent);
    }

    public void showItemsList(View view) {
        Intent intent = new Intent(this, ItemsActivity.class);
        intent.putExtra(ItemsActivity.PERSON_ID, person.getId());
        startActivity(intent);
    }
}

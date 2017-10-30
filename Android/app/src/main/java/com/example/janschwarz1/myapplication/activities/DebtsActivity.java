package com.example.janschwarz1.myapplication.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TabHost;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.Ratio;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.utils.AppSettings;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import io.realm.RealmResults;

public class DebtsActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Debts.PERSON_ID";
    public static String OWES_TO_ID = "com.example.janschwarz1.myapplication.activities.Debts.OWES_ID";

    private Person person;
    private Person owesToPerson;
    private ListView debtsList;
    private ListView claimsList;
    private TitleValueAdapter<Ratio> debtsAdapter;
    private TitleValueAdapter<Ratio> claimsAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_debts);

        Intent intent = getIntent();
        String personId = intent.getStringExtra(DebtsActivity.PERSON_ID);
        String owesToId = intent.getStringExtra(DebtsActivity.OWES_TO_ID);
        person = RealmManager.shared.person(personId);
        owesToPerson = RealmManager.shared.person(owesToId);

        setTitle(person.getName() + " owes to " + owesToPerson.getName());

        TabHost host = (TabHost)findViewById(R.id.debtsTabHost);
        host.setup();

        //Tab 1
        TabHost.TabSpec spec = host.newTabSpec("tab1");
        spec.setContent(R.id.debtsTab1);
        spec.setIndicator(person.getName() + " consumed " + String.format( "%.2f", person.consumedFrom(owesToPerson)) + " " + AppSettings.shared.getReferenceCurrency().getCode());
        host.addTab(spec);

        //Tab 2
        spec = host.newTabSpec("tab2");
        spec.setContent(R.id.debtsTab2);
        spec.setIndicator(person.getName() + " payed " + String.format( "%.2f", person.payedFor(owesToPerson)) + " " + AppSettings.shared.getReferenceCurrency().getCode());
        host.addTab(spec);

        debtsList = (ListView) findViewById(R.id.debtsListViewDebts);
        claimsList = (ListView) findViewById(R.id.debtsListViewClaims);

        RealmResults<Ratio> debts = RealmManager.shared.ratios(owesToPerson, person);
        debtsAdapter = new TitleValueAdapter(debts, new DebtsActivityDataSource());
        debtsList.setAdapter(debtsAdapter);

        RealmResults<Ratio> claims = RealmManager.shared.ratios(person, owesToPerson);
        claimsAdapter = new TitleValueAdapter(claims, new DebtsActivityDataSource());
        claimsList.setAdapter(claimsAdapter);
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

class DebtsActivityDataSource implements TitleValueAdapterDataSource<Ratio> {

    DebtsActivityDataSource() {
    }

    @Override
    public String getTitleForItem(Ratio item) {
        return item.getItem().getName();
    }

    @Override
    public String getValueForItem(Ratio item) {
        return String.format( "%.2f", item.getRatio() * item.getItem().value());
    }
}

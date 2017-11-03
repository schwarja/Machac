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
import android.widget.TextView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.Ratio;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.utils.AppSettings;
import com.example.janschwarz1.myapplication.utils.RealmManager;
import com.example.janschwarz1.myapplication.utils.TitleValueAdapter;

import io.realm.RealmChangeListener;
import io.realm.RealmResults;

public class DebtsActivity extends AppCompatActivity {

    public static String PERSON_ID = "com.example.janschwarz1.myapplication.activities.Debts.PERSON_ID";
    public static String OWES_TO_ID = "com.example.janschwarz1.myapplication.activities.Debts.OWES_ID";

    private RealmResults<Ratio> debts;
    private RealmResults<Ratio> claims;
    private Person person;
    private Person owesToPerson;
    private ListView debtsList;
    private ListView claimsList;
    private TabHost tabHost;
    private TabHost.TabSpec debtsSpec;
    private TabHost.TabSpec claimsSpec;
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

        tabHost = (TabHost)findViewById(R.id.debtsTabHost);
        tabHost.setup();

        //Tab 1
        debtsSpec = tabHost.newTabSpec("tab1");
        debtsSpec.setContent(R.id.debtsTab1);
        debtsSpec.setIndicator(person.getName() + " consumed " + String.format( "%.2f", person.consumedFrom(owesToPerson)) + " " + AppSettings.shared.getReferenceCurrency().getCode());
        tabHost.addTab(debtsSpec);

        //Tab 2
        claimsSpec = tabHost.newTabSpec("tab2");
        claimsSpec.setContent(R.id.debtsTab2);
        claimsSpec.setIndicator(person.getName() + " payed " + String.format( "%.2f", person.payedFor(owesToPerson)) + " " + AppSettings.shared.getReferenceCurrency().getCode());
        tabHost.addTab(claimsSpec);

        debtsList = (ListView) findViewById(R.id.debtsListViewDebts);
        claimsList = (ListView) findViewById(R.id.debtsListViewClaims);

        debts = RealmManager.shared.ratios(owesToPerson, person);
        debtsAdapter = new TitleValueAdapter(debts, new DebtsActivityDataSource());
        debtsList.setAdapter(debtsAdapter);

        claims = RealmManager.shared.ratios(person, owesToPerson);
        claimsAdapter = new TitleValueAdapter(claims, new DebtsActivityDataSource());
        claimsList.setAdapter(claimsAdapter);

        debts.addChangeListener(new RealmChangeListener<RealmResults<Ratio>>() {
            @Override
            public void onChange(RealmResults<Ratio> results) {
                setupTabs();
            }
        });

        claims.addChangeListener(new RealmChangeListener<RealmResults<Ratio>>() {
            @Override
            public void onChange(RealmResults<Ratio> results) {
                setupTabs();
            }
        });

        //setupTabs();
    }

    @Override
    protected void onDestroy() {
        debts.removeAllChangeListeners();
        claims.removeAllChangeListeners();

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

    protected void setupTabs() {
        TextView debts = (TextView) tabHost.getTabWidget().getChildAt(0).findViewById(android.R.id.title);
        debts.setText(person.getName() + " consumed " + String.format( "%.2f", person.consumedFrom(owesToPerson)) + " " + AppSettings.shared.getReferenceCurrency().getCode());
        TextView claims = (TextView) tabHost.getTabWidget().getChildAt(1).findViewById(android.R.id.title);
        claims.setText(person.getName() + " payed " + String.format( "%.2f", person.payedFor(owesToPerson)) + " " + AppSettings.shared.getReferenceCurrency().getCode());
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

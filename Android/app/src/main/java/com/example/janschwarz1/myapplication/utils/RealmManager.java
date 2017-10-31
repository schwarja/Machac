package com.example.janschwarz1.myapplication.utils;

import android.content.Context;

import com.example.janschwarz1.myapplication.models.Currency;
import com.example.janschwarz1.myapplication.models.Item;
import com.example.janschwarz1.myapplication.models.ItemWithCascadeDelete;
import com.example.janschwarz1.myapplication.models.Person;
import com.example.janschwarz1.myapplication.models.Ratio;

import java.util.ArrayList;

import io.realm.ObjectServerError;
import io.realm.Realm;
import io.realm.RealmObject;
import io.realm.RealmResults;
import io.realm.SyncConfiguration;
import io.realm.SyncCredentials;
import io.realm.SyncUser;

/**
 * Created by janschwarz1 on 25/10/2017.
 */

public class RealmManager {

    public static RealmManager shared = new RealmManager();

    public interface ChangeListener {
        void onChange();
    }

    private ChangeListener listener;

    public Realm realm;

    public void initialize(Context context) {
        try {
            Realm.init(context);
            SyncCredentials myCredentials = SyncCredentials.usernamePassword("schwarja", "SuperTajneHeslo/12");
            if (SyncUser.currentUser() != null) {
                createRealm(SyncUser.currentUser());
            } else {
                SyncUser.loginAsync(myCredentials, "http://52.233.193.105:9080", new SyncUser.Callback() {

                    @Override
                    public void onSuccess(SyncUser user) {
                        createRealm(user);
                    }

                    @Override
                    public void onError(ObjectServerError error) {
                        realm = null;
                    }
                });
            }
        }
        catch (Exception e) {
            System.out.println(e.toString());
            throw e;
        }
    }

    protected void createRealm(SyncUser user) {
        SyncConfiguration config = new SyncConfiguration.Builder(user, "realm://52.233.193.105:9080/~/userRealm")
                .schemaVersion(3)
                .build();
        // Use the config
        realm = Realm.getInstance(config);
        if (listener != null) {
            listener.onChange();
        }
    }

    public ChangeListener getListener() {
        return listener;
    }

    public void setListener(ChangeListener listener) {
        this.listener = listener;
    }

    public RealmResults<Person> people() {
        return realm.where(Person.class).findAllSorted("name");
    }

    public RealmResults<Person> peopleWithout(String[] ids) {
        return realm.where(Person.class).not().in("id", ids).findAllSorted("name");
    }

    public RealmResults<Person> peopleWith(String[] ids) {
        return realm.where(Person.class).in("id", ids).findAllSorted("name");
    }

    public Person person(String id) {
        return realm.where(Person.class).equalTo("id", id).findFirst();
    }

    public RealmResults<Currency> currencies() {
        return realm.where(Currency.class).findAllSorted("code");
    }

    public Currency currency(String code) {
        if (code != null) {
            return realm.where(Currency.class).equalTo("code", code).findFirst();
        }
        return null;
    }

    public Currency referenceCurrency() {
        return realm.where(Currency.class).equalTo("isReference", true).findFirst();
    }

    public RealmResults<Item> itemsOf(Person person) {
        return realm.where(Item.class).equalTo("owner.id", person.getId()).findAllSorted("name");
    }

    public RealmResults<Ratio> ratiosCosumedBy(Person person) {
        return realm.where(Ratio.class).equalTo("debtor.id", person.getId()).findAll();
    }

    public RealmResults<Ratio> ratiosOwnedBy(Person person) {
        return realm.where(Ratio.class).equalTo("item.owner.id", person.getId()).findAll();
    }

    public RealmResults<Ratio> ratios(Person owner, Person consumer) {
        return realm.where(Ratio.class)
                .equalTo("item.owner.id", owner.getId())
                .equalTo("debtor.id", consumer.getId())
                .findAllSorted("item.name");
    }

    public RealmResults<Ratio> ratiosOfItem(Item item) {
        return realm.where(Ratio.class).equalTo("item.id", item.getId()).findAll();
    }

    public Ratio ratio(String id) {
        return realm.where(Ratio.class).equalTo("id", id).findFirst();
    }

    public Item item(String id) {
        return realm.where(Item.class).equalTo("id", id).findFirst();
    }

    public RealmResults<Item> itemsInCurrency(Currency cur) {
        return realm.where(Item.class).equalTo("currency.code", cur.getCode()).findAll();
    }

    public void write(RealmObject object) {
        realm.beginTransaction();
        try {
            realm.insertOrUpdate(object);
            realm.commitTransaction();
        }
        catch (Exception ex) {
            realm.cancelTransaction();
        }
    }

    public <T extends RealmObject & ItemWithCascadeDelete> void remove(T object) {
        realm.beginTransaction();
        try {
            object.cascadeDelete();
            realm.commitTransaction();
        }
        catch (Exception ex) {
            realm.cancelTransaction();
        }
    }
}

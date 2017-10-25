package com.example.janschwarz1.myapplication.utils;

import android.content.Context;

import com.example.janschwarz1.myapplication.models.Currency;
import com.example.janschwarz1.myapplication.models.Person;

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

    private Realm realm;

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
    }

    public RealmResults<Person> people() {
        return realm.where(Person.class).findAllSorted("name");
    }
    public RealmResults<Currency> currencies() {
        return realm.where(Currency.class).findAllSorted("code");
    }

    public void write(RealmObject object) {
        realm.beginTransaction();
        try {
            realm.insertOrUpdate(object);
        }
        catch (Exception ex) {
            realm.cancelTransaction();
        }
        finally {
            realm.commitTransaction();
        }
    }

    public void remove(RealmObject object) {
        realm.beginTransaction();
        try {
            object.deleteFromRealm();
        }
        catch (Exception ex) {
            realm.cancelTransaction();
        }
        finally {
            realm.commitTransaction();
        }
    }
}

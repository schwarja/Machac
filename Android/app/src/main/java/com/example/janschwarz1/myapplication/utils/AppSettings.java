package com.example.janschwarz1.myapplication.utils;

import com.example.janschwarz1.myapplication.models.Currency;

import io.realm.RealmResults;

/**
 * Created by janschwarz1 on 27/10/2017.
 */

public class AppSettings {

    public static AppSettings shared = new AppSettings();

    private RealmResults<Currency> currencies = RealmManager.shared.currencies();

    private Currency referenceCurrency;

    public void initialize() {
        Currency reference = RealmManager.shared.referenceCurrency();
        if (reference != null) {
            referenceCurrency = reference;
        }
        else {
            Currency czk = new Currency(Currency.defaultCode, 1.0, true);
            RealmManager.shared.write(czk);
            referenceCurrency = czk;
        }

    }

    public RealmResults<Currency> getCurrencies() {
        return currencies;
    }

    public Currency getReferenceCurrency() {
        return referenceCurrency;
    }

}

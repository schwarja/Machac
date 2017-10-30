package com.example.janschwarz1.myapplication.models;

import com.example.janschwarz1.myapplication.utils.AppSettings;

import java.util.UUID;

import io.realm.RealmObject;
import io.realm.RealmResults;
import io.realm.annotations.LinkingObjects;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.Required;

/**
 * Created by janschwarz1 on 27/10/2017.
 */

public class Item extends RealmObject implements TitleValueAdapterItem {
    @PrimaryKey@Required
    private String id;
    @Required
    private String name;
    private Person owner;
    @Required
    private Double valueInCurrency;
    private Currency currency;
    @LinkingObjects("item")
    private final RealmResults<Ratio> ratios = null;

    public Item() {

    }

    public Item(String name, Person owner, Double valueInCurrency, Currency currency) {
        this(UUID.randomUUID().toString(), name, owner, valueInCurrency, currency);
    }

    public Item(String id, String name, Person owner, Double valueInCurrency, Currency currency) {
        this.id = id;
        this.name = name;
        this.owner = owner;
        this.valueInCurrency = valueInCurrency;
        this.currency = currency;
    }

    public Double value() {
        Double czkValue = valueInCurrency * currency.getRelationToCzk();
        if (AppSettings.shared.getReferenceCurrency().isDefault()) {
            return czkValue;
        } else {
            return czkValue / AppSettings.shared.getReferenceCurrency().getRelationToCzk();
        }
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Person getOwner() {
        return owner;
    }

    public Double getValueInCurrency() {
        return valueInCurrency;
    }

    public Currency getCurrency() {
        return currency;
    }

    public RealmResults<Ratio> getRatios() {
        return ratios;
    }

    @Override
    public String getTitle() {
        return name;
    }

    @Override
    public String getValue() {
        return "";
    }
}

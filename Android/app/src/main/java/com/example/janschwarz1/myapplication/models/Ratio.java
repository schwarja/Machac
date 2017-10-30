package com.example.janschwarz1.myapplication.models;

import java.util.UUID;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.Required;

/**
 * Created by janschwarz1 on 27/10/2017.
 */

public class Ratio extends RealmObject implements TitleValueAdapterItem {
    @PrimaryKey@Required
    private String id;
    @Required
    private Double ratio;
    private Item item;
    private Person debtor;

    public Ratio() {

    }

    public Ratio(Item item, Person debtor, Double ratio) {
        this(UUID.randomUUID().toString(), item, debtor, ratio);
    }

    public Ratio(String id, Item item, Person debtor, Double ratio) {
        this.id = id;
        this.item = item;
        this.debtor = debtor;
        this.ratio = ratio;
    }

    public String getId() {
        return id;
    }

    public Double getRatio() {
        return ratio;
    }

    public Item getItem() {
        return item;
    }

    public Person getDebtor() {
        return debtor;
    }

    @Override
    public String getTitle() {
        return debtor.getName();
    }

    @Override
    public String getValue() {
        return String.format( "%.2f", ratio);
    }
}

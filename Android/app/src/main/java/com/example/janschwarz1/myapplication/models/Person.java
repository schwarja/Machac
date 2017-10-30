package com.example.janschwarz1.myapplication.models;

import com.example.janschwarz1.myapplication.utils.RealmManager;

import io.realm.RealmObject;
import io.realm.RealmResults;
import io.realm.annotations.LinkingObjects;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.Required;
import java.util.UUID;

/**
 * Created by janschwarz1 on 25/10/2017.
 */

public class Person extends RealmObject implements TitleValueAdapterItem {
    @PrimaryKey@Required
    private String id;
    @Required
    private String name;
    @LinkingObjects("owner")
    private final RealmResults<Item> items = null;
    @LinkingObjects("debtor")
    private final RealmResults<Ratio> ratios = null;

    public Person() {
        this("");
    }

    public Person(String name) {
        this(UUID.randomUUID().toString(), name);
    }

    public Person(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public Double owes() {
        RealmResults<Person> people = RealmManager.shared.peopleWithout(new Person[]{this});
        Double sum = 0.0;
        for (Person p: people) {
            sum += owesTo(p);
        }
        return sum;
    }

    public Double isOwedTo() {
        RealmResults<Person> people = RealmManager.shared.peopleWithout(new Person[]{this});
        Double sum = 0.0;
        for (Person p: people) {
            sum += wantsFrom(p);
        }
        return sum;
    }

    public Double owesTo(Person person) {
        Double plus = payedFor(person);
        Double minus = consumedFrom(person);
        return Math.max(0, minus - plus);
    }

    public Double wantsFrom(Person person) {
        Double plus = payedFor(person);
        Double minus = consumedFrom(person);
        return Math.max(0, plus - minus);
    }

    public Double consumedFrom(Person person) {
        RealmResults<Ratio> ratios = RealmManager.shared.ratios(person,this);
        Double sum = 0.0;
        for (Ratio ratio: ratios) {
            sum += ratio.getRatio() * ratio.getItem().value();
        }
        return sum;
    }

    public Double payedFor(Person person) {
        RealmResults<Ratio> ratios = RealmManager.shared.ratios(this, person);
        Double sum = 0.0;
        for (Ratio ratio: ratios) {
            sum += ratio.getRatio() * ratio.getItem().value();
        }
        return sum;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public RealmResults<Item> getItems() {
        return items;
    }

    public RealmResults<Ratio> getRatios() {
        return ratios;
    }

    public String getTitle() {
        return name;
    }

    public String getValue() {
        return "";
    }

}

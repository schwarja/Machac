package com.example.janschwarz1.myapplication.models;

import io.realm.RealmObject;
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

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getTitle() {
        return name;
    }

    public String getValue() {
        return "";
    }
}

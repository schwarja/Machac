package com.example.janschwarz1.myapplication.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.Required;

/**
 * Created by janschwarz1 on 25/10/2017.
 */

public class Currency extends RealmObject implements TitleValueAdapterItem {
    static public final String defaultCode = "CZK";

    @PrimaryKey@Required
    private String code;
    @Required
    private Double relationToCzk;
    @Required
    private Boolean isReference;

    public Boolean isDefault() {
        return code == Currency.defaultCode;
    }

    public Currency() {

    }

    public Currency(String code, Double relationToCzk, Boolean isReference) {
        this.code = code;
        this.relationToCzk = relationToCzk;
        this.isReference = isReference;
    }

    public String getCode() {
        return code;
    }

    public Double getRelationToCzk() {
        return relationToCzk;
    }

    public Boolean getReference() {
        return isReference;
    }

    @Override
    public String getTitle() {
        return code;
    }

    @Override
    public String getValue() {
        return "1 " + code + " = " + String.format( "%.2f", relationToCzk) + " " + Currency.defaultCode;
    }
}

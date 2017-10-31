package com.example.janschwarz1.myapplication.models;

import com.example.janschwarz1.myapplication.utils.AppSettings;
import com.example.janschwarz1.myapplication.utils.RealmManager;

import java.io.Serializable;
import java.util.ArrayList;

import io.realm.RealmObject;
import io.realm.RealmResults;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.Required;

/**
 * Created by janschwarz1 on 25/10/2017.
 */

public class Currency extends RealmObject implements TitleValueAdapterItem, ItemWithCascadeDelete {
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

    @Override
    public void cascadeDelete() {
        RealmResults<Item> items = RealmManager.shared.itemsInCurrency(this);
        ArrayList<RealmObject> updatedObjects = new ArrayList<>();

        for (Item item: items) {
            Item updatedItem = new Item(item.getId(), item.getName(), item.getOwner(), item.value(), AppSettings.shared.getReferenceCurrency());
            updatedObjects.add(updatedItem);

            for (Ratio ratio: item.getRatios()) {
                Ratio updatedRatio = new Ratio(ratio.getId(), updatedItem, ratio.getDebtor(), ratio.getRatio());
                updatedObjects.add(updatedRatio);
            }
        }

        for (RealmObject obj: updatedObjects) {
            RealmManager.shared.realm.insertOrUpdate(obj);
        }

        this.deleteFromRealm();
    }
}

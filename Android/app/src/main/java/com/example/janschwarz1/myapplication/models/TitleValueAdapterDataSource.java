package com.example.janschwarz1.myapplication.models;

/**
 * Created by janschwarz1 on 30/10/2017.
 */

public interface TitleValueAdapterDataSource<T> {
    public String getTitleForItem(T item);
    public String getValueForItem(T item);
}

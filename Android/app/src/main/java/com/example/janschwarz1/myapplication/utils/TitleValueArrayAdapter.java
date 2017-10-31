package com.example.janschwarz1.myapplication.utils;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.example.janschwarz1.myapplication.R;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterDataSource;
import com.example.janschwarz1.myapplication.models.TitleValueAdapterItem;

import io.realm.OrderedRealmCollection;
import io.realm.RealmObject;

/**
 * Created by janschwarz1 on 31/10/2017.
 */

public class TitleValueArrayAdapter<T extends RealmObject & TitleValueAdapterItem> extends ArrayAdapter {

    private static class ViewHolder {
        TextView titleText;
        TextView valueText;
    }

    private LayoutInflater mInflater;
    private TitleValueAdapterDataSource<T> dataSource;

    public TitleValueArrayAdapter(Context context, T[] objects) {
        super(context, R.layout.list_item_title_value, objects);
    }

    public TitleValueArrayAdapter(Context context, T[] objects, TitleValueAdapterDataSource<T> dataSource) {
        this(context, objects);
        this.dataSource = dataSource;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        TitleValueArrayAdapter.ViewHolder viewHolder;
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.list_item_title_value, parent, false);
            viewHolder = new TitleValueArrayAdapter.ViewHolder();
            viewHolder.titleText = (TextView) convertView.findViewById(R.id.titleTextView);
            viewHolder.valueText = (TextView) convertView.findViewById(R.id.valueTextView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (TitleValueArrayAdapter.ViewHolder) convertView.getTag();
        }

        final T item = (T) this.getItem(position);
        if (item != null) {
            if (dataSource == null) {
                viewHolder.titleText.setText(item.getTitle());
                viewHolder.valueText.setText(item.getValue());
            }
            else {
                viewHolder.titleText.setText(dataSource.getTitleForItem(item));
                viewHolder.valueText.setText(dataSource.getValueForItem(item));
            }
        }
        return convertView;
    }
}

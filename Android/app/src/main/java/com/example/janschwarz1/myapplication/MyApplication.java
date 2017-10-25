package com.example.janschwarz1.myapplication;
import android.app.Application;

import com.example.janschwarz1.myapplication.utils.RealmManager;

/**
 * Created by janschwarz1 on 25/10/2017.
 */

public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        RealmManager.shared.initialize(this);
    }
}

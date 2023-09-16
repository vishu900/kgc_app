package com.dataproject2;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;

public class MainActivity extends FlutterFragmentActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        //  super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegister.registerGeneratedPlugins(flutterEngine);
    }
    
}

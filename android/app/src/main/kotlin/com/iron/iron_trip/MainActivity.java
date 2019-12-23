package com.iron.iron_trip;

import android.os.Bundle;

import com.iron.asr_plugin.AsrPlugin;
import com.iron.location_plugin.LocationPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        registerSelfPlugin();
    }

    //百度语音监听
    private void registerSelfPlugin() {
        AsrPlugin.registerWith(registrarFor("com.iron.asr_plugin.AsrPlugin"));
        LocationPlugin.registerWith(registrarFor("com.iron.location_plugin.LocationPlugin"));
    }
}

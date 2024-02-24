package com.congthiep.millionaire

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.provider.Settings
import android.content.ActivityNotFoundException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "congthiep"
    private var isExecuting = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "openWifiSetting"){
                openWifiSetting()
            } else {
                result.notImplemented()
            }   
        }
    }

     fun openWifiSetting() {
        try {
            startActivity(Intent(Settings.ACTION_WIFI_SETTINGS))
        } catch (e: ActivityNotFoundException) {
            println("Wifi Setting Error")
        }
    }
}

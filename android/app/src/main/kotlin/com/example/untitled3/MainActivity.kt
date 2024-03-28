package com.example.untitled3

import android.content.Context
import android.database.Cursor
import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = "flutter_channel"

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
                .setMethodCallHandler { call: MethodCall, result: Result ->
                    when (call.method) {
                        "getRingtones" -> {
                            val ringtones = getAllRingtones(this@MainActivity)
                            result.success(ringtones)
                        }
                        else -> {
                            result.notImplemented()
                        }
                    }
                }
    }

    private fun getAllRingtones(context: Context): List<String> {
        val manager = RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)
        val cursor: Cursor = manager.cursor
        val list: MutableList<String> = mutableListOf()

        while (cursor.moveToNext()) {
            val notificationTitle: String = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(notificationTitle)
        }

        cursor.close() // Close the cursor after use to prevent memory leaks

        return list
    }
}


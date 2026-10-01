package com.example.frontend

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import com.gdelataillade.alarm.alarm.AlarmService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private var pendingAlarmId: Int? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleAlarmIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        setIntent(intent)

        handleAlarmIntent(intent)
    }

    private fun configureAlarmWindow(isAlarmLaunch: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(isAlarmLaunch)
            setTurnScreenOn(isAlarmLaunch)
        } else {
            val alarmFlags =
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            if (isAlarmLaunch) {
                window.addFlags(alarmFlags)
            } else {
                window.clearFlags(alarmFlags)
            }
        }
        if (isAlarmLaunch) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    private fun handleAlarmIntent(intent: Intent) {
        val isAlarmLaunch = intent.action == AlarmService.ACTION_RING
        configureAlarmWindow(isAlarmLaunch)
        if (!isAlarmLaunch) return

        val alarmId = intent.getIntExtra(AlarmService.EXTRA_ALARM_ID, -1)
        if (alarmId == -1) return

        pendingAlarmId = alarmId
    }

    private fun canUseFullScreenIntent(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return true
        }
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return notificationManager.canUseFullScreenIntent()
    }

    private fun openFullScreenIntentSettings() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return

        val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
            data = Uri.parse("package:$packageName")
        }
        startActivity(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "medapp/alarm_launch"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeAlarmLaunch" -> {
                    // Ler o campo aqui (em vez de capturar acima) é o que torna
                    // isso seguro: configureFlutterEngine roda dentro de
                    // super.onCreate, antes do onCreate chamar handleAlarmIntent.
                    result.success(pendingAlarmId)
                    pendingAlarmId = null
                }
                "canUseFullScreenIntent" -> result.success(canUseFullScreenIntent())
                "openFullScreenIntentSettings" -> {
                    openFullScreenIntentSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
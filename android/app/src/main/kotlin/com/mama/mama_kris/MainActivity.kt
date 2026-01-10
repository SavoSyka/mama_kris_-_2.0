package com.mama.mama_kris

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/cloudpayments"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startPayment") {
                // Здесь будем вызывать SDK
                val amount = call.argument<String>("amount")
                val currency = call.argument<String>("currency")
                val description = call.argument<String>("description")
                // Инициализируем платеж и передаем данные в SDK
                // ...
                // Пример результата
                result.success("Платеж запущен: $amount $currency, $description")
            } else {
                result.notImplemented()
            }
        }
    }
}

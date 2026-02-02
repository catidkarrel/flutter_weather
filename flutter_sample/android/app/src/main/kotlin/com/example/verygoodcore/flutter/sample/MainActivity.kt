package com.example.verygoodcore.flutter_sample

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
	private val CHANNEL = "sample_channel"

	// Set up the MethodChannel with the same name as defined in Dart
	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

			when (call.method) {
				"getDataFromNative" -> {
					// Perform platform-specific operations and obtain the result
					val data = getDataFromNative()
					// Send the result back to Flutter
					result.success(data)
				}
				"getUnreadCount" -> {
					val unreadCount = getUnreadCount()
					result.success(unreadCount)
				}
				else -> {
					result.notImplemented()
				}
			}

			if (call.method == "getDataFromNative") {
				// Perform platform-specific operations and obtain the result
				val data = getDataFromNative()

				// Send the result back to Flutter
				result.success(data)
			} else {
				result.notImplemented()
			}
		}
	}

	private fun getDataFromNative(): String {
		// Perform platform-specific operations to fetch the data
		return "This is the data passed from android native"
	}

	private fun getUnreadCount(): Int {
		// Perform platform-specific operations to fetch the data
		return 10
	}
}

package com.ahmed.applist_detector_flutter

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

/** ApplistDetectorFlutterPlugin */
class ApplistDetectorFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private var emptyList = listOf<String>()


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "applist_detector_flutter")
        channel.setMethodCallHandler(this)

        System.loadLibrary("applist_detector")

        TODO("Handle Exceptions for loading the library")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "abnormal_environment" -> {
                checkAbnormalEnv(result)
                return
            }

            "file_detection" -> {
                checkFileDetection(call, result)
                return
            }

            "xposed_modules" -> {
                checkXposedModules(call, result)
                return
            }

            "magisk_app" -> {
                checkMagiskApp(call, result)
                return
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkAbnormalEnv(result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()
        try {
            val dtc = AbnormalEnvironment(context)
            val r = dtc.run(emptyList, detail)

            val data = HashMap<String, String>()
            data["type"] = r.toString()
            result.success(data)
        } catch (e: Exception) {
            result.error("ABNORMAL_ENV_CHECK_FAILED", e.message, null)
        }
    }

    private fun checkFileDetection(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        val useSysCall = call.argument<Boolean>("use_syscall") ?: false
        val packages = call.argument<List<String>>("packages") ?: emptyList()
        if (packages.isEmpty()) {
            result.error("MAGISK_DETECTION_FAILED", "No packages to check", null)
            return
        }

        try {
            val dtc = FileDetection(context, useSysCall)
            val r = dtc.run(packages, detail)

            val data = HashMap<String, String>()
            data["type"] = r.toString()
            result.success(data)
        } catch (e: Exception) {
            result.error("FILE_DETECTION_FAILED", e.message, null)
        }
    }

    private fun checkXposedModules(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        try {
            val dtc = XposedModules(context)
            val r = dtc.run(null, detail)

            val data = HashMap<String, String>()
            data["type"] = r.toString()
            result.success(data)
        } catch (e: Exception) {
            result.error("XPOSED_DETECTION_FAILED", e.message, null)
        }
    }

    private fun checkMagiskApp(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()
        try {
            val dtc = MagiskApp(context)
            val r = dtc.run(null, detail)

            val data = HashMap<String, String>()
            data["type"] = r.toString()
            result.success(data)
        } catch (e: Exception) {
            result.error("MAGISK_DETECTION_FAILED", e.message, null)
        }
    }
}

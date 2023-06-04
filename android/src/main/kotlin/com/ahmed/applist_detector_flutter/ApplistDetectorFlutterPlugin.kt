package com.ahmed.applist_detector_flutter

import android.content.Context
import android.util.Log
import com.ahmed.applist_detector_flutter.library.*

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
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "com.ahmed/applist_detector_flutter"
        )
        channel.setMethodCallHandler(this)

        try {
            System.loadLibrary("applist_detector")
        } catch (e: Exception) {
            Log.e("ApplistDetectorFlutterPlugin", "Failed to load applist_detector library", e)
            val data = HashMap<String, Any>()
            data["error"] = e.message ?: "Unknown error"
            channel.invokeMethod("native_library_load_failed", data)
        }
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
                checkXposedModules(result)
                return
            }

            "magisk_app" -> {
                checkMagiskApp(result)
                return
            }

            "pm_command" -> {
                checkPMCommand(call, result)
                return
            }

            "pm_conventional_apis" -> {
                checkConventionalAPIS(call, result)
                return
            }

            "pm_sundry_apis" -> {
                checkSundryAPIS(call, result)
                return
            }

            "pm_query_intent_activities" -> {
                checkPMQueryIntentActivities(call, result)
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

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
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

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("FILE_DETECTION_FAILED", e.message, null)
        }
    }

    private fun checkXposedModules(result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        try {
            val dtc = XposedModules(context)
            val r = dtc.run(null, detail)

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("XPOSED_DETECTION_FAILED", e.message, null)
        }
    }

    private fun checkMagiskApp(result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()
        try {
            val dtc = MagiskApp(context)
            val r = dtc.run(null, detail)

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("MAGISK_DETECTION_FAILED", e.message, null)
        }
    }

    private fun checkPMCommand(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        val packages = call.argument<List<String>>("packages") ?: emptyList()
        if (packages.isEmpty()) {
            result.error("CHECK_PM_COMMAND_FAILED", "No packages to check", null)
            return
        }

        try {
            val dtc = PMCommand(context)
            val r = dtc.run(packages, detail)

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("CHECK_PM_COMMAND_FAILED", e.message, null)
        }
    }

    private fun checkConventionalAPIS(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        val packages = call.argument<List<String>>("packages") ?: emptyList()
        if (packages.isEmpty()) {
            result.error("CHECK_PM_CONVENTIONAL_APIS_FAILED", "No packages to check", null)
            return
        }

        try {
            val dtc = PMConventionalAPIs(context)
            val r = dtc.run(packages, detail)

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("CHECK_PM_CONVENTIONAL_APIS_FAILED", "No packages to check", null)
        }
    }

    private fun checkSundryAPIS(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        val packages = call.argument<List<String>>("packages") ?: emptyList()
        if (packages.isEmpty()) {
            result.error("CHECK_PM_SUNDRY_APIS_FAILED", "No packages to check", null)
            return
        }

        try {
            val dtc = PMSundryAPIs(context)
            val r = dtc.run(packages, detail)

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("CHECK_PM_SUNDRY_APIS_FAILED", "No packages to check", null)
        }
    }

    private fun checkPMQueryIntentActivities(call: MethodCall, result: Result) {
        val detail = mutableListOf<Pair<String, IDetector.Result>>()

        val packages = call.argument<List<String>>("packages") ?: emptyList()
        if (packages.isEmpty()) {
            result.error("CHECK_PM_QUERY_INTENT_ACTIVITIES", "No packages to check", null)
            return
        }

        try {
            val dtc = PMQueryIntentActivities(context)
            val r = dtc.run(packages, detail)

            val data = HashMap<String, Any>()
            data["type"] = r.toString()
            data["details"] = detail.toHashMap()
            result.success(data)
        } catch (e: Exception) {
            result.error("CHECK_PM_QUERY_INTENT_ACTIVITIES", "No packages to check", null)
        }
    }

}

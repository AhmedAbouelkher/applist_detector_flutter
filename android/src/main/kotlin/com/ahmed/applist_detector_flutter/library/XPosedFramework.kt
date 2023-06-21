package com.ahmed.applist_detector_flutter.library

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager

// Copied from: https://github.com/GantMan/jail-monkey
// Copied from: https://github.com/weikaizhi/AntiDebug
class XPosedFramework(context: Context) : IDetector(context) {
    override val name = "XPosed Framework"

    private val dangerousPackages = setOf(
        "de.robv.android.xposed.installer",
        "com.saurik.substrate",
        "de.robv.android.xposed"
    )

    private fun advancedHookDetection(): Result {
        try {
            throw Exception()
        } catch (e: Exception) {
            var zygoteInitCallCount = 0
            for (stackTraceElement in e.stackTrace) {
                if (stackTraceElement.className == "com.android.internal.os.ZygoteInit") {
                    zygoteInitCallCount++
                    if (zygoteInitCallCount == 2) {
                        return Result.FOUND
                    }
                }
                if (stackTraceElement.className == "com.saurik.substrate.MS$2"
                    && stackTraceElement.methodName == "invoked"
                ) {
                    return Result.FOUND
                }

                if (stackTraceElement.className == "de.robv.android.xposed.XposedBridge"
                    && stackTraceElement.methodName == "main"
                ) {
                    return Result.FOUND
                }

                if (stackTraceElement.className == "de.robv.android.xposed.XposedBridge"
                    && stackTraceElement.methodName == "handleHookedMethod"
                ) {
                    return Result.FOUND
                }
            }
        }
        return Result.NOT_FOUND
    }

    @SuppressLint("QueryPermissionsNeeded")
    override fun run(packages: Collection<String>?, detail: Detail?): Result {
        var result = Result.NOT_FOUND
        val add: (Pair<String, Result>) -> Unit = {
            result = result.coerceAtLeast(it.second)
            detail?.add(it)
        }
        val packageManager = context.packageManager
        val applicationList = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
        for (applicationInfo in applicationList) {
            if (dangerousPackages.contains(applicationInfo.packageName)) {
                add(packageManager.getApplicationLabel(applicationInfo) as String to Result.FOUND)
            }
        }
        add("Advanced Hook Detection" to advancedHookDetection())
        return result
    }

}
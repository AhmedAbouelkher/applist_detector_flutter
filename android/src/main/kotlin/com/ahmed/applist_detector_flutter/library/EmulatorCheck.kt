package com.ahmed.applist_detector_flutter.library

import android.content.Context
import android.os.Build
import java.io.File

class EmulatorCheck(context: Context) : IDetector(context) {
    override val name = "Emulator Check"

    private fun checkEmulator(): Boolean {
        return ((
                Build.BRAND.startsWith("generic")
                        && Build.DEVICE.startsWith("generic")
                )
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk ")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator"))
    }

    private fun getCPUInfo(): HashMap<String, String> {
        val hd = hashMapOf<String, String>()
        val f = File("/proc/cpuinfo");
        if (!f.exists() || !f.canRead()) {
            return hd
        }
        val skipKeys = setOf("flags")

        val lines = f.readLines()
        for (line in lines) {
            val l = line.trim()
            if (l.isEmpty() || l.isBlank()) continue

            val data = l.split(":")
            if (data.size <= 1) continue

            val key = data[0].trim().replace(" ", "_").lowercase()
            if (key.isEmpty() || key.isBlank()) continue
            if (skipKeys.contains(key)) continue

            val value = data[1].trim().lowercase()
            if (value.isEmpty() || value.isBlank()) continue

            // check if key is already present, if yes, compare
            // the values, if different, add a suffix to the key
            if (hd.containsKey(key)) {
                val oldValue = hd[key]
                if (oldValue != value) {
                    hd[key + "_1"] = value
                }
            } else {
                hd[key] = value
            }

        }
        return hd
    }


    private fun checkForAMDandIntel(v: String): Boolean {
        return (v.contains("intel", true)
                || v.contains("amd", true)
                || v.contains("ryzen", true))
    }

    override fun run(packages: Collection<String>?, detail: Detail?): Result {
        if (packages != null) throw IllegalArgumentException("packages should be null")

        var result = Result.NOT_FOUND
        val add: (Pair<String, Result>) -> Unit = {
            result = result.coerceAtLeast(it.second)
            detail?.add(it)
        }

        val basicCheck = checkEmulator()
        add("basic_check" to if (basicCheck) Result.FOUND else Result.NOT_FOUND)

        val checkedDeviceInfo = (Build.HOST.contains("ubuntu", true)
                || Build.BOARD.contains("windows", true)
                || Build.HARDWARE.contains("windows", true))
        add("device_info" to if (checkedDeviceInfo) Result.FOUND else Result.NOT_FOUND)


        val cpuInfo = getCPUInfo()
        if (cpuInfo.isEmpty()) {
            add("device_info" to if (checkedDeviceInfo) Result.FOUND else Result.NOT_FOUND)
        }

        val vendorID = cpuInfo["vendor_id"] ?: ""
        val checkedVendorID = checkForAMDandIntel(vendorID)
        add("sus_vendor_id" to if (checkedVendorID) Result.FOUND else Result.NOT_FOUND)

        if (!cpuInfo.contains("model_name")) {
            val processor = cpuInfo["processor"] ?: ""
            val checkedProcessor = checkForAMDandIntel(processor)
            add("sus_processor" to if (checkedProcessor) Result.FOUND else Result.NOT_FOUND)
        } else {
            val modelName = cpuInfo["model_name"] ?: ""
            val checkedModelName = checkForAMDandIntel(modelName)
            add("sus_model_name" to if (checkedModelName) Result.FOUND else Result.NOT_FOUND)
        }

        return result
    }
}
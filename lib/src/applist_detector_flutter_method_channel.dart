import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'applist_detector_flutter_platform_interface.dart';
import 'models/result.dart';
import 'default_packages.dart';

/// An implementation of [ApplistDetectorFlutterPlatform] that uses method channels.
class MethodChannelApplistDetectorFlutter
    extends ApplistDetectorFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('com.ahmed/applist_detector_flutter');

  @override
  Future<DetectorResult> abnormalEnvironment() async {
    final result =
        await methodChannel.invokeMethod<Map>('abnormal_environment');
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking abnormal environment failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> fileDetection({
    Set<String> packages = const {},
    bool useSysCall = false,
  }) async {
    final pkgs = packages.isEmpty ? kDefaultPackages : packages;
    final result = await methodChannel.invokeMethod<Map>(
      'file_detection',
      {
        'packages': pkgs.toList(),
        'use_syscall': useSysCall,
      },
    );
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking file detection failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> xposedModules({bool lspatch = false}) async {
    final result = await methodChannel.invokeMethod<Map>('xposed_modules', {
      'lspatch': lspatch,
    });
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking Xposed modules failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> magiskApp() async {
    final result = await methodChannel.invokeMethod<Map>('magisk_app');
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking Xposed modules failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> pmCommand({Set<String> packages = const {}}) async {
    final pkgs = packages.isEmpty ? kDefaultPackages : packages;
    final result = await methodChannel
        .invokeMethod<Map>('pm_command', {'packages': pkgs.toList()});
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking pm command failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> pmConventionalAPIs(
      {Set<String> packages = const {}}) async {
    final pkgs = packages.isEmpty ? kDefaultPackages : packages;
    final result = await methodChannel
        .invokeMethod<Map>('pm_conventional_apis', {'packages': pkgs.toList()});
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking pm conventional APIs failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> pmSundryAPIs({Set<String> packages = const {}}) async {
    final pkgs = packages.isEmpty ? kDefaultPackages : packages;
    final result = await methodChannel
        .invokeMethod<Map>('pm_sundry_apis', {'packages': pkgs.toList()});
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking pm sundry APIs failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> pmQueryIntentActivities(
      {Set<String> packages = const {}}) async {
    final pkgs = packages.isEmpty ? kDefaultPackages : packages;
    final result = await methodChannel.invokeMethod<Map>(
        'pm_query_intent_activities', {'packages': pkgs.toList()});
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking pm query intent activities failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> settingsProps() async {
    final result = await methodChannel.invokeMethod<Map>('settings_props');
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking settings props failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }

  @override
  Future<DetectorResult> emulatorCheck() async {
    final result = await methodChannel.invokeMethod<Map>('emulator_check');
    if (result == null) {
      throw PlatformException(
        code: "NULL_RESULT",
        message: "Checking emulator check failed.",
      );
    }
    return DetectorResult.fromMap(result);
  }
}

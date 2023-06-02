import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '_default_packages.dart';
import 'applist_detector_flutter_platform_interface.dart';
import 'models/result.dart';

/// An implementation of [ApplistDetectorFlutterPlatform] that uses method channels.
class MethodChannelApplistDetectorFlutter
    extends ApplistDetectorFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('applist_detector_flutter');

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
    // ignore: no_leading_underscores_for_local_identifiers
    final _packages = packages.isEmpty ? kDefaultPackages : packages;
    final result = await methodChannel.invokeMethod<Map>(
      'file_detection',
      {
        'packages': _packages.toList(),
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
  Future<DetectorResult> xposedModules() async {
    final result = await methodChannel.invokeMethod<Map>('xposed_modules');
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
}

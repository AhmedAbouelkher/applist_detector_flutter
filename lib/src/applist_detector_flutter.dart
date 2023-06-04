import 'applist_detector_flutter_platform_interface.dart';
import 'models/result.dart';

class ApplistDetectorFlutter {
  Future<DetectorResult> abnormalEnvironment() async {
    return ApplistDetectorFlutterPlatform.instance.abnormalEnvironment();
  }

  Future<DetectorResult> fileDetection({
    Set<String> packages = const {},
    bool useSysCall = false,
  }) async {
    return ApplistDetectorFlutterPlatform.instance.fileDetection(
      packages: packages,
      useSysCall: useSysCall,
    );
  }

  Future<DetectorResult> xposedModules({bool lspatch =false}) async {
    return ApplistDetectorFlutterPlatform.instance.xposedModules(lspatch: lspatch);
  }

  Future<DetectorResult> magiskApp() async {
    return ApplistDetectorFlutterPlatform.instance.magiskApp();
  }

  Future<DetectorResult> pmCommand({Set<String> packages = const {}}) async {
    return ApplistDetectorFlutterPlatform.instance
        .pmCommand(packages: packages);
  }

  Future<DetectorResult> pmConventionalAPIs(
      {Set<String> packages = const {}}) async {
    return ApplistDetectorFlutterPlatform.instance
        .pmConventionalAPIs(packages: packages);
  }

  Future<DetectorResult> pmSundryAPIs({Set<String> packages = const {}}) async {
    return ApplistDetectorFlutterPlatform.instance
        .pmSundryAPIs(packages: packages);
  }

  Future<DetectorResult> pmQueryIntentActivities(
      {Set<String> packages = const {}}) async {
    return ApplistDetectorFlutterPlatform.instance
        .pmQueryIntentActivities(packages: packages);
  }
}

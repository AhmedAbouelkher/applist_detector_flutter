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

  Future<DetectorResult> xposedModules() async {
    return ApplistDetectorFlutterPlatform.instance.xposedModules();
  }

  Future<DetectorResult> magiskApp() async {
    return ApplistDetectorFlutterPlatform.instance.magiskApp();
  }
}

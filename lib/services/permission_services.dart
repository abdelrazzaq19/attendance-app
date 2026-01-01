import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionState { granted, denied, permanentlyDenied, unknown }

class PermissionServices extends GetxService {
  Future<PermissionState> get cameraPermissionStatus async {
    final status = await Permission.camera.status;
    return _convertStatus(status);
  }

  Future<PermissionState> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return _convertStatus(status);
  }

  Future<PermissionState> get locationPermissionStatus async {
    final status = await Permission.location.status;
    return _convertStatus(status);
  }

  Future<PermissionState> requestLocationPermission() async {
    final status = await Permission.location.request();
    return _convertStatus(status);
  }

  Future<void> openSetting() async {
    await openAppSettings();
  }

  PermissionState _convertStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return PermissionState.granted;
      case PermissionStatus.permanentlyDenied:
        return PermissionState.permanentlyDenied;
      case PermissionStatus.denied:
        return PermissionState.denied;
      default:
        return PermissionState.unknown;
    }
  }
}

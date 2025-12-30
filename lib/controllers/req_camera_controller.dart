import 'package:attendance_app/services/permission_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReqCameraController extends GetxController with WidgetsBindingObserver {
  final PermissionServices _permissionServices = Get.find<PermissionServices>();

  Rx<PermissionState> cameraPermissionStatus = PermissionState.unknown.obs;

  RxString feedbackMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await checkameraPermission();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkameraPermission();
    }
  }

  Future<void> checkameraPermission() async {
    final status = await _permissionServices.cameraPermissionStatus;
    _changeStatus(status);
  }

  Future<void> requestCameraPermission() async {
    final status = await _permissionServices.requestCameraPermission();
    _changeStatus(status);
  }

  void _changeStatus(PermissionState status) {
    cameraPermissionStatus(status);

    if (status == PermissionState.granted) {
      feedbackMessage('Camera access granted');
    } else {
      feedbackMessage('You need camera acces to continue');
    }
  }

  void next(String nextRoute) async {
    if (cameraPermissionStatus.value == PermissionState.granted) {
      Get.offNamed(nextRoute);
    } else if (cameraPermissionStatus.value ==
        PermissionState.permanentlyDenied) {
      await _permissionServices.openSetting();
    } else {
      await requestCameraPermission(); // 21:39
    }
  }
}

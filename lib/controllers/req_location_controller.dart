import 'package:attendance_app/pages/request_location_page.dart';
import 'package:attendance_app/services/permission_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReqLocationController extends GetxController with WidgetsBindingObserver {
  final PermissionServices _permissionServices = Get.find<PermissionServices>();

  Rx<PermissionState> locationPermissionStatus = PermissionState.unknown.obs;

  RxString feedbackMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await checkLocationPermission();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkLocationPermission();
    }
  }

  Future<void> checkLocationPermission() async {
    final status = await _permissionServices.locationPermissionStatus;
    _changeStatus(status);
  }

  Future<void> requestLocationPermission() async {
    final status = await _permissionServices.requestLocationPermission();
    _changeStatus(status);
  }

  void _changeStatus(PermissionState status) {
    locationPermissionStatus(status);

    if (status == PermissionState.granted) {
      feedbackMessage('Location access granted');
    } else {
      feedbackMessage('You need location acces to continue');
    }
  }

  void next(RequestLocationProps data) async {
    if (locationPermissionStatus.value == PermissionState.granted) {
      if (await _permissionServices.cameraPermissionStatus ==
          PermissionState.granted) {
        Get.offNamed(data.targetRoute!);
        return;
      }
      Get.offNamed(data.nextRoute, arguments: data.targetRoute);
    } else if (locationPermissionStatus.value ==
        PermissionState.permanentlyDenied) {
      await _permissionServices.openSetting();
    } else {
      await requestLocationPermission();
    }
  }
}

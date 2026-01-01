import 'dart:developer';

import 'package:attendance_app/models/attendance_model.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController
    with StateMixin<List<AttendanceModel>> {
  final UserService _userService = Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      change(null, status: RxStatus.loading());
      final List<AttendanceModel> data = await _userService.loadAttendance();
      log('Attendance data: $data');
      if (data.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(data, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}

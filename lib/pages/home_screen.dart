import 'package:attendance_app/controllers/history_controller.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:attendance_app/widgets/attendance_history.dart';
import 'package:attendance_app/widgets/main_card.dart';
import 'package:attendance_app/widgets/profile_info.dart';
import 'package:attendance_app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final UserService userService = Get.find<UserService>();

  final HistoryController _historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        actions: [
          ThemeToggle(),
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                ProfileInfo(userService: userService),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              );
            },
            icon: Icon(Icons.person_outlined),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 16),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _historyController.loadData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Maincard(userService: userService),
              SizedBox(height: 24),
              AttendanceHistory(),
            ],
          ),
        ),
      ),
    );
  }
}

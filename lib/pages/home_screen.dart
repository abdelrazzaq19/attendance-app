import 'package:attendance_app/services/user_service.dart';
import 'package:attendance_app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final UserService userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          ThemeToggle(),
          IconButton(onPressed: userService.logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(child: Text('Home Page')),
    );
  }
}

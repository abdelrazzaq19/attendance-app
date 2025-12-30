import 'package:attendance_app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggle extends StatelessWidget {
  ThemeToggle({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IconButton(
        onPressed: themeController.toggleTheme,
        icon: themeController.themeMode == ThemeMode.light
            ? Icon(Icons.dark_mode_outlined)
            : Icon(Icons.light_mode_outlined),
      ),
    );
  }
}

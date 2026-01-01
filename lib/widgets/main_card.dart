import 'package:attendance_app/core/routes.dart';
import 'package:attendance_app/pages/request_location_page.dart';
import 'package:attendance_app/services/permission_services.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Maincard extends StatelessWidget {
  Maincard({super.key, required this.userService});

  final UserService userService;

  final PermissionServices _permissionServices = Get.find<PermissionServices>();

  void attendanceButton() async {
    final bool isLocationGranted =
        await _permissionServices.locationPermissionStatus ==
        PermissionState.granted;

    final bool isCameraGranted =
        await _permissionServices.cameraPermissionStatus ==
        PermissionState.granted;

    if (!isLocationGranted) {
      Get.toNamed(
        AppRouter.requestLocation,
        arguments: RequestLocationProps(
          nextRoute: AppRouter.requestCamera,
          targetRoute: AppRouter.attendance,
        ),
      );
      return;
    }

    if (!isCameraGranted) {
      Get.toNamed(AppRouter.requestCamera, arguments: AppRouter.attendance);
      return;
    }

    if (isLocationGranted && isCameraGranted) {
      Get.toNamed(AppRouter.attendance);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(100),
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${userService.firestoreUser.value!.displayname}!',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'You are logged in as ${userService.firestoreUser.value!.email}.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          FilledButton.icon(
            onPressed: attendanceButton,
            style: FilledButton.styleFrom(minimumSize: Size.fromHeight(50)),
            icon: Icon(Icons.schedule),
            label: Text('Take Attendance'),
          ),
        ],
      ),
    );
  }
}

import 'package:attendance_app/controllers/req_camera_controller.dart';
import 'package:attendance_app/services/permission_services.dart';
import 'package:attendance_app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestCameraPage extends StatelessWidget {
  final String nextRoute;
  RequestCameraPage({super.key, required this.nextRoute});

  final ReqCameraController controller = Get.put(ReqCameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ThemeToggle()],
        actionsPadding: EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_outlined,
                size: 76,
                color:
                    controller.cameraPermissionStatus.value ==
                        PermissionStatus.granted
                    ? Colors.green
                    : Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                controller.feedbackMessage.value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => controller.next(nextRoute),
                child: Text(
                  controller.cameraPermissionStatus.value ==
                          PermissionState.granted
                      ? 'Continue'
                      : 'Request camera access',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

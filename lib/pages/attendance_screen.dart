import 'package:attendance_app/controllers/attendance_controller.dart';
import 'package:attendance_app/widgets/theme_toggle.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});

  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enroll Page'),
        actions: [ThemeToggle()],
        actionsPadding: EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(controller.feedbackMessage.value),
              ],
            ),
          );
        }

        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CameraPreview(controller.cameraController),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  controller.feedbackMessage.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  margin: EdgeInsets.all(54),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(140),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FloatingActionButton.large(
                onPressed: controller.capture,
                shape: CircleBorder(),
                child: Icon(Icons.camera),
              ),
            ),

            Obx(() {
              if (!controller.isProcessing.value) {
                return SizedBox.shrink();
              }

              return Container(
                color: Colors.black.withAlpha(180),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        controller.feedbackMessage.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}

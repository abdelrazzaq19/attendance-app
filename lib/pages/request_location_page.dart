import 'package:attendance_app/controllers/req_location_controller.dart';
import 'package:attendance_app/services/permission_services.dart';
import 'package:attendance_app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestLocationProps {
  final String nextRoute;
  final String? targetRoute;

  RequestLocationProps({required this.nextRoute, this.targetRoute});
}

class RequestLocationPage extends StatelessWidget {
  final RequestLocationProps props;
  RequestLocationPage({super.key, required this.props});

  final ReqLocationController controller = Get.put(ReqLocationController());

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
                Icons.location_on_outlined,
                size: 76,
                color:
                    controller.locationPermissionStatus.value ==
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
                onPressed: () => controller.next(props),
                child: Text(
                  controller.locationPermissionStatus.value ==
                          PermissionState.granted
                      ? 'Continue'
                      : 'Request location access',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

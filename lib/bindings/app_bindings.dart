import 'package:attendance_app/services/cloudinary_service.dart';
import 'package:attendance_app/services/face_recognition_service.dart';
import 'package:attendance_app/services/permission_services.dart';
import 'package:attendance_app/services/target_location_service.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionServices(), permanent: true);
    Get.put(UserService(), permanent: true);
    Get.put(FaceRecognitionService(), permanent: true);
    Get.put(CloudinaryService(), permanent: true);
    Get.put(TargetLocationService(), permanent: true);
  }
}

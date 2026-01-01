import 'package:attendance_app/bindings/auth_binding.dart';
import 'package:attendance_app/pages/attendance_screen.dart';
import 'package:attendance_app/pages/enroll_screen.dart';
import 'package:attendance_app/pages/home_screen.dart';
import 'package:attendance_app/pages/login_screen.dart';
import 'package:attendance_app/pages/register_screen.dart';
import 'package:attendance_app/pages/request_camera_page.dart';
import 'package:attendance_app/pages/request_location_page.dart';
import 'package:attendance_app/pages/root_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String requestCamera = '/request_camera';
  static const String enroll = '/enroll';
  static const String requestLocation = '/request_location';
  static const String attendance = '/attendance';

  static const String initialRoute = root;

  static final List<GetPage> routes = [
    GetPage(name: root, page: () => RootScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: login, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: requestCamera,
      page: () {
        final String nextRoute = Get.arguments as String;
        return RequestCameraPage(nextRoute: nextRoute);
      },
    ),
    GetPage(name: enroll, page: () => EnrollScreen()),
    GetPage(
      name: requestLocation,
      page: () {
        final RequestLocationProps args = Get.arguments as RequestLocationProps;
        return RequestLocationPage(props: args);
      },
    ),
    GetPage(name: attendance, page: () => AttendanceScreen()), 
  ];
}

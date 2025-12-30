import 'package:attendance_app/core/routes.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool _isLoading = false.obs;
  final RxBool _isPasswordHidden = true.obs;
  final RxBool _isConfirmPasswordHidden = true.obs;

  bool get isLoading => _isLoading.value;
  bool get isPasswordHidden => _isPasswordHidden.value;
  bool get isConfirmPasswordHidden => _isConfirmPasswordHidden.value;

  void togglePasswordVisibility() {
    _isPasswordHidden.value = !_isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordHidden.value = !_isConfirmPasswordHidden.value;
  }

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    _isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.offAllNamed(AppRouter.home);
    } on FirebaseAuthException catch (e) {
      Helper.showError(e.message ?? 'Registration failed');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }
    _isLoading.value = true;

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      User? user = userCredential.user;
      if (user != null) {
        // Create user doc
        await userService.createUserDocument(user, nameController.text.trim());
        await user.updateDisplayName(nameController.text.trim());
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      Helper.showError(e.message ?? 'Registration failed');
    } finally {
      _isLoading.value = false;
    }
  }
}

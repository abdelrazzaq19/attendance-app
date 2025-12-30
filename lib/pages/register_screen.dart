import 'package:attendance_app/controllers/auth_controller.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:attendance_app/utils/validator.dart';
import 'package:attendance_app/widgets/theme_toggle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ThemeToggle()],
        actionsPadding: EdgeInsets.only(right: 16),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: authController.registerFormKey,
            child: Column(
              children: [
                Text(
                  'Create account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Register to continue',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 50),
                TextFormField(
                  controller: authController.nameController,
                  validator: (value) => Validator.name(value),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onTapOutside: Helper.onTapOutside,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: authController.emailController,
                  validator: (value) => Validator.email(value),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onTapOutside: Helper.onTapOutside,
                ),
                SizedBox(height: 16),
                Obx(
                  () => TextFormField(
                    controller: authController.passwordController,
                    validator: (value) => Validator.newPassword(value),
                    obscureText: authController.isPasswordHidden,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        onPressed: authController.togglePasswordVisibility,
                        icon: Icon(
                          authController.isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onTapOutside: Helper.onTapOutside,
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () => TextFormField(
                    controller: authController.confirmPasswordController,
                    validator: (value) => Validator.confirmPassword(
                      value,
                      authController.passwordController.text,
                    ),
                    obscureText: authController.isConfirmPasswordHidden,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        onPressed:
                            authController.toggleConfirmPasswordVisibility,
                        icon: Icon(
                          authController.isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onTapOutside: Helper.onTapOutside,
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () => FilledButton(
                    onPressed: authController.isLoading
                        ? null
                        : authController.register,
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: authController.isLoading
                        ? CircularProgressIndicator()
                        : Text('Register'),
                  ),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.back();
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

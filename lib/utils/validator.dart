import 'package:get/get.dart';

class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    } else {
      return null;
    }
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if(value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if(GetUtils.isNumericOnly(value)){
      return 'Name must not be in full numeric';
    }
    return null;
  }

  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if(value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if(value != password) {
      return 'Password does not match';
    }
    return null;
  }
}

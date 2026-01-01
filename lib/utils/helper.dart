import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withAlpha(180),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withAlpha(180),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  static void onTapOutside(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('MM dd, HH:mm:ss a').format(dateTime);
    return dateFormat;
  }

  static void openMap(GeoPoint location) async {
    final latitude = location.latitude;
    final longitude = location.longitude;

    final geoUri = Uri.parse(
      'geo:$latitude, $longitude?q=$latitude, $longitude(Attendance Location)',
    );

    try {
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
      } else {
        final mapUri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        );
        if (await canLaunchUrl(mapUri)) {
          await launchUrl(mapUri);
        } else {
          throw Exception('Failed to open map');
        }
      }
    } catch (e) {
      log('Failed to open map: $e');
      showError('Failed to open map');
    }
  }
}

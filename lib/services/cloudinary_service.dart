import 'dart:developer';
import 'dart:io';

import 'package:attendance_app/env/env.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:get/get.dart';

class CloudinaryService extends GetxService {
  late final Cloudinary _cloudinary;

  @override
  void onInit() {
    super.onInit();
    _cloudinary = Cloudinary.unsignedConfig(cloudName: Env.cloudName);
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final response = await _cloudinary.unsignedUpload(
        uploadPreset: Env.uploadPreset,
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'attendance',
        fileName: 'selfie_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isResultOk) {
        return response.secureUrl!;
      } else {
        throw Exception(
          'Failed to upload image to cloudinary: ${response.error ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Error uploading image to Cloudinary: $e');
      throw Exception('Error uploading image to Cloudinary: $e');
    }
  }
}

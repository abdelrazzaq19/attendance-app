import 'dart:developer';
import 'dart:io';

import 'package:attendance_app/services/cloudinary_service.dart';
import 'package:attendance_app/services/face_recognition_service.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class EnrollController extends GetxController {
  late final CameraController cameraController;
  late List<CameraDescription> _cameras;
  CameraDescription? _frontCamera;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
  );

  RxBool isCameraInitialized = false.obs;
  RxString feedbackMessage = 'loading...'.obs;
  RxBool isProcessing = false.obs;

  final FaceRecognitionService _faceRecognitionService =
      Get.find<FaceRecognitionService>();

  final CloudinaryService _cloudinaryService = Get.find<CloudinaryService>();

  final UserService _userService = Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  void _initCamera() async {
    try {
      _cameras = await availableCameras();
      _frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      cameraController = CameraController(
        _frontCamera!,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();
      isCameraInitialized(true);
      feedbackMessage('Please place your face in the oval');
    } catch (e) {
      log('Error initializing camera: $e');
      feedbackMessage('Error initializing camera.');
    }
  }

  Future<void> captureAndEnrollFace() async {
    if (!isCameraInitialized.value) return;

    isProcessing(true);
    feedbackMessage('Processing...');

    try {
      final XFile imageXFile = await cameraController.takePicture();
      final File imageFile = File(imageXFile.path);

      feedbackMessage('Detecting face...');
      final InputImage inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        throw Exception('No face detected');
      }

      if (faces.length > 1) {
        throw Exception('Multiple faces detected');
      }

      final Face face = faces.first;

      feedbackMessage('Getting face embedding...');

      final List<double> embedding = _faceRecognitionService.getEmbedding(
        imageFile,
        face,
      );

      if (embedding.isEmpty) {
        throw Exception('Failed to get face embedding');
      }

      final String imageUrl = await _cloudinaryService.uploadImage(imageFile);

      feedbackMessage('Saving Face data...');

      await _userService.saveEmbedding(embedding, imageUrl);
    } catch (e) {
      log(e.toString());
      Helper.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isProcessing(false);
      feedbackMessage('Please place your face in the oval');
    }
  }
}

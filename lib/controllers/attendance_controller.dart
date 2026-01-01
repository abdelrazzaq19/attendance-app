import 'dart:developer';
import 'dart:io';

//import 'package:attendance_app/services/cloudinary_service.dart';
import 'package:attendance_app/core/routes.dart';
import 'package:attendance_app/services/face_recognition_service.dart';
import 'package:attendance_app/services/target_location_service.dart';
import 'package:attendance_app/services/user_service.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class AttendanceController extends GetxController {
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

  //final CloudinaryService _cloudinaryService = Get.find<CloudinaryService>();

  final UserService _userService = Get.find<UserService>();

  final TargetLocationService _targetLocationService =
      Get.find<TargetLocationService>();

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

  Future<void> capture() async {
    if (!isCameraInitialized.value) return;

    isProcessing(true);

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

      feedbackMessage('Getting location...');

    try {
      final position = await Geolocator.getCurrentPosition();

      final double locationDistance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _targetLocationService.targetLocation.value!.coords.latitude,
        _targetLocationService.targetLocation.value!.coords.longitude,
      );

      if (locationDistance >
          _targetLocationService.targetLocation.value!.radius) {
        throw Exception('You are ${locationDistance.round()} meters away. Please try again.');
      }

      feedbackMessage('Location varified');

      feedbackMessage('Getting face embedding...');

      final List<double> newEmbedding = _faceRecognitionService.getEmbedding(
        imageFile,
        face,
      );

      if (newEmbedding.isEmpty) {
        throw Exception('Failed to get face embedding');
      }

      final List<double> saveEmbedding = _userService.getFaceEmbedding;

      if (saveEmbedding.isEmpty) {
        throw Exception('Face not register');
      }

      final bool isMatch = _faceRecognitionService.compareFace(
        newEmbedding,
        saveEmbedding,
      );

      if (!isMatch) {
        throw Exception('Face not match');
      }

      feedbackMessage('Identity verified. Clocking you in...');

      await _userService
          .recordAttendance(position, locationDistance)
          .then((value) => Get.offAllNamed(AppRouter.home));
    } catch (e) {
      log(e.toString());
      Helper.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isProcessing(false);
      feedbackMessage('Please place your face in the oval');
    }
  }
}

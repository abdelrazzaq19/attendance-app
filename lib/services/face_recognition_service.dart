import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'dart:typed_data';

import 'package:attendance_app/core/constant.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService extends GetxService {
  Interpreter? _interpreter;
  static const int _inputSize = 112;

  @override
  void onInit() {
    super.onInit(); // 2:46
    _loadModel();
  }

  @override
  void onClose() {
    _interpreter?.close();
    super.onClose();
  }

  Future<File?> downloadModel(String modelName) async {
    final model = await FirebaseModelDownloader.instance.getModel(
      modelName,
      FirebaseModelDownloadType.localModelUpdateInBackground,
      FirebaseModelDownloadConditions(
        iosAllowsCellularAccess: true,
        iosAllowsBackgroundDownloading: true,
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );

    return model.file;
  }

  Future<void> _loadModel() async {
    try {
      File? modelFile = await downloadModel(Constant.modelName);
      if (modelFile != null) {
        _interpreter = Interpreter.fromFile(modelFile);
        log('Model loaded successfully');
      }
    } catch (e) {
      log('Error loading model: $e');
      Helper.showError('Failed to load face recognition model');
    }
  }

  Float32List _preprocessImage(File imageFile, Face face) {
    final Uint8List bytes = imageFile.readAsBytesSync();
    final img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('Could not decode image');
    }

    final Rect boundingBox = face.boundingBox;

    final img.Image croppedImage = img.copyCrop(
      originalImage,
      x: boundingBox.left.toInt(),
      y: boundingBox.top.toInt(),
      width: boundingBox.width.toInt(),
      height: boundingBox.height.toInt(),
    );

    final img.Image resizedImage = img.copyResize(
      croppedImage,
      width: _inputSize,
      height: _inputSize,
    );

    final Float32List imageAsList = Float32List(
      1 * _inputSize * _inputSize * 3,
    );
    int pixelIndex = 0;

    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final img.Pixel pixel = resizedImage.getPixel(x, y);

        imageAsList[pixelIndex++] = (pixel.r - 127.5) / 128;
        imageAsList[pixelIndex++] = (pixel.g - 127.5) / 128;
        imageAsList[pixelIndex++] = (pixel.b - 127.5) / 128;
      }
    }

    return imageAsList;
  }

  List<double> getEmbedding(File imageFile, Face face) {
    if (_interpreter == null) {
      log('Interpreter not initialized');
      return [];
    }

    final Float32List inputList = _preprocessImage(imageFile, face);

    final input = inputList.reshape([1, _inputSize, _inputSize, 3]);
    final output = List.filled(1 * 192, 0.0).reshape([1, 192]);

    try {
      _interpreter!.run(input, output);
    } catch (e) {
      log('Error during inference: $e');
      Helper.showError('Face recognition failed during inference');
      return [];
    }

    final List<dynamic> outputList = output[0] as List<dynamic>;
    final List<double> embeddingList = [];

    for (var i in outputList) {
      embeddingList.add((i as num).toDouble());
    }

    return embeddingList;
  }

  bool compareFace(List<double> newEmbedding, List<double> existingEmbedding) {
    double threshold = 1.0;

    double sumOfSquares = 0.0;

    for (int i = 0; i < newEmbedding.length; i++) {
      double diff = newEmbedding[i] - existingEmbedding[i];
      sumOfSquares += diff * diff;
    }

    double distance = sqrt(sumOfSquares);
    return distance < threshold;
  }
}

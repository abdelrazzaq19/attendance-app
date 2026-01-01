import 'dart:developer';

import 'package:attendance_app/core/constant.dart';
import 'package:attendance_app/models/target_location_model.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TargetLocationService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rxn<TargetLocationModel> targetLocation = Rxn<TargetLocationModel>();

  @override
  void onReady() {
    super.onReady();
    loadTargetLocationDoc();
  }

  Future<void> loadTargetLocationDoc() async {
    try {
      final QuerySnapshot = await _firestore
          .collection(Constant.configCollection)
          .limit(1)
          .get();

      final doc = QuerySnapshot.docs.first;

      if (doc.exists) {
        targetLocation.value = TargetLocationModel.fromMap(doc.data());
        log(
          'Target location document loaded successfully. ${targetLocation.value?.coords.latitude}, ${targetLocation.value?.coords.longitude}, ${targetLocation.value?.radius}',
        );
      } else {
        throw 'Target location not found';
      }
    } on FirebaseException catch (e) {
      log(e.message ?? 'Failed to load target location');
      Helper.showError(e.message ?? 'something went wrong');
    }
  }
}

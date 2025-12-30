import 'dart:developer';

import 'package:attendance_app/core/constant.dart';
import 'package:attendance_app/core/routes.dart';
import 'package:attendance_app/models/user_model.dart';
import 'package:attendance_app/services/permission_services.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PermissionServices _permissionServices = Get.find<PermissionServices>();

  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed(AppRouter.login);
    } else {
      await _loadUserDocument(user.uid);

      if (firestoreUser.value == null) {
        Get.offAllNamed(AppRouter.login);
      } else {
        if (firestoreUser.value!.faceEmbedding == null) {
          if (await _permissionServices.cameraPermissionStatus ==
              PermissionState.granted) {
            Get.offAllNamed(AppRouter.enroll);
          } else {
            Get.offAllNamed(
              AppRouter.requestCamera,
              arguments: AppRouter.enroll,
            );
          }
        } else {
          Get.offAllNamed(AppRouter.home);
        }
      }
    }
    FlutterNativeSplash.remove();
  }

  Future<void> _loadUserDocument(String uid) async {
    try {
      final doc = await _firestore
          .collection(Constant.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        firestoreUser.value = UserModel.fromMap(doc.data()!);
      } else {
        throw 'User document does not exist. Please contact support';
      }
    } on FirebaseException catch (e) {
      await logout();
      Helper.showError(e.message ?? 'something went wrong');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> createUserDocument(User user, String displayName) async {
    try {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayname: displayName,
        createdAt: Timestamp.now(),
      );
      await _firestore
          .collection(Constant.usersCollection)
          .doc(user.uid)
          .set(newUser.toMap());
    } on FirebaseException catch (e) {
      log(e.message ?? 'Failed to create user document');
      Helper.showError(e.message ?? 'something went wrong');
    }
  }

  Future<void> saveEmbedding(List<double> embedding, String imageUrl) async {
    try {
      if (firebaseUser.value == null) {
        Helper.showError('User not logged in');
        return;
      }

      await _firestore
          .collection(Constant.usersCollection)
          .doc(firebaseUser.value!.uid)
          .update({'faceEmbedding': embedding, 'imageUrl': imageUrl});

      _loadUserDocument(firebaseUser.value!.uid);

      Helper.showSuccess('Face Enrollment Completed! Welcome!');
      Get.offAllNamed(AppRouter.home);
    } on Exception catch (e) {
      log('Failed to save embedding: $e');
      throw Exception('Failed to save embedding: $e');
    }
  }
}

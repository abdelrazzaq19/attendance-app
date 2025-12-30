import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayname;
  final String role;
  final Timestamp createdAt;
  final List<dynamic>? faceEmbedding;
  final String? faceImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayname,
    this.role = 'basic',
    required this.createdAt,
    this.faceEmbedding,
    this.faceImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayname': displayname,
      'role': role,
      'createdAt': createdAt,
      'faceEmbedding': faceEmbedding,
      'faceImageUrl': faceImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayname: map['displayname'] ?? '',
      role: map['role'] ?? 'basic',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      faceEmbedding: map['faceEmbedding'] != null
          ? List.from(map['faceEmbedding'])
          : null,
      faceImageUrl: map['faceImageUrl'] ?? '',
    );
  }
}

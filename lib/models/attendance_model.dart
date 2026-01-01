import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String? id;
  final String userId;
  final String type;
  final GeoPoint location;
  final double distanceToTargetMeters;
  final Timestamp timeStamp;

  AttendanceModel({
    this.id,
    required this.userId,
    required this.type,
    required this.location,
    required this.distanceToTargetMeters,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'location': location,
      'distanceToTargetMeters': distanceToTargetMeters,
      'timeStamp': timeStamp,
    }; 
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      userId: map['userId'],
      type: map['type'],
      location: map['location'],
      distanceToTargetMeters: map['distanceToTargetMeters'],
      timeStamp: map['timeStamp'],
    );
  }
}

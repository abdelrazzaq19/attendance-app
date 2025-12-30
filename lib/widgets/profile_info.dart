import 'dart:math' as math;

import 'package:attendance_app/services/user_service.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.userService});

  final UserService userService;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Transform.rotate(
            angle: -math.pi / 2,
            child: Icon(Icons.chevron_left),
          ),
          SizedBox(height: 16),
          CircleAvatar(
            radius: 80,
            backgroundImage:
                userService.firestoreUser.value!.faceImageUrl != null
                ? NetworkImage(userService.firestoreUser.value!.faceImageUrl!)
                : null,
          ),
          SizedBox(height: 16),
          Text(
            userService.firestoreUser.value!.displayname,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            userService.firestoreUser.value!.email,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await userService.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

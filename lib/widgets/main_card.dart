import 'package:attendance_app/services/user_service.dart';
import 'package:flutter/material.dart';

class Maincard extends StatelessWidget {
  const Maincard({super.key, required this.userService});

  final UserService userService;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(100),
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${userService.firestoreUser.value!.displayname}!',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'You are logged in as ${userService.firestoreUser.value!.email}.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(minimumSize: Size.fromHeight(50)),
            icon: Icon(Icons.schedule),
            label: Text('Take Attendance'),
          ),
        ],
      ),
    );
  }
}

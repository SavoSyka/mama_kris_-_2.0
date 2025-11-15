import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLogoutDialog(BuildContext context, VoidCallback onLogout) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true, // tap outside to dismiss
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Are you sure you want to log out from your account?',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Cancel
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              onLogout(); // Perform logout
            },
            isDestructiveAction: true,
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  );
}

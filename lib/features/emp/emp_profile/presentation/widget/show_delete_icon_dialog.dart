import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mama_kris/core/constants/app_palette.dart';

void showDeleteAccountDialog(
  BuildContext context,
  VoidCallback onDelete, {
  bool isApplicant = false,
}) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true, // Allow tap outside to dismiss
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Are you sure you want to delete your account? '
            'This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Cancel
            },
            child: Text(
              'Cancel',

              style: TextStyle(
                color: isApplicant
                    ? AppPalette.primaryColor
                    : AppPalette.empPrimaryColor,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              onDelete(); // Perform delete action
            },
            isDestructiveAction: true,
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';

final class MessageDialog {
  MessageDialog._();

  static void showError(BuildContext context, Object error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('$error'),
          actions: [
            Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                icon: const Icon(Icons.close),
              ),
            )
          ],
        );
      },
    );
  }

  static Future<bool> confirm(
    BuildContext context, {
    String message = 'Are you sure you want to proceed?',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: Text(message),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) => value == true);
  }
}

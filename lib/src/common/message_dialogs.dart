import 'package:flutter/material.dart';

abstract class MessageDialogs {
  MessageDialogs._();

  static Future<bool> confirm(
    BuildContext context, {
    String message = '',
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
          ],
        );
      },
    ).then((value) => value == true);
  }

  static Future<void> showError(
    BuildContext context,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('$error'),
          actions: [
            Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

// Reusable widget to show alert popup on invalid input
Widget alertMessage(context,
    {String title = 'Invalid Input',
    String content = 'Please all the fields appropriately'}) {
  return AlertDialog(title: Text(title), content: Text(content), actions: [
    TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Ok'))
  ]);
}

import 'package:flutter/material.dart';

void _alert(BuildContext context, String alertFieldName) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$alertFieldName is empty'),
        content: Text('Please enter $alertFieldName!'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:plantplanetapp/utility/my_style.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> normalDialog(
      {required String title, required String message}) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: MyStyle().showLogo(),
          title: Text(
            title,
            style: MyStyle().redStyle(),
          ),
          subtitle: Text(
            message,
            style: MyStyle().darkStyle(),
          ),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

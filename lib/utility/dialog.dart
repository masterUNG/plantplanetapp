import 'package:flutter/material.dart';
import 'package:plantplanetapp/utility/my_style.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
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
          child: Text('OK'),
        ),
      ],
    ),
  );
}

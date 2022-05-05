import 'package:flutter/material.dart';

class MyStyle {
  //Color
  Color dark = Color(0xff003d32);
  Color primary = Color(0xff00685b);
  Color light = Color(0xff439688);
  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(0, 61, 50, 0.1),
    100: Color.fromRGBO(0, 61, 50, 0.2),
    200: Color.fromRGBO(0, 61, 50, 0.3),
    300: Color.fromRGBO(0, 61, 50, 0.4),
    400: Color.fromRGBO(0, 61, 50, 0.5),
    500: Color.fromRGBO(0, 61, 50, 0.6),
    600: Color.fromRGBO(0, 61, 50, 0.7),
    700: Color.fromRGBO(0, 61, 50, 0.8),
    800: Color.fromRGBO(0, 61, 50, 0.9),
    900: Color.fromRGBO(0, 61, 50, 1.0),
  };

  //Text
  TextStyle darkStyle() => TextStyle(color: MyStyle().dark);
  TextStyle lightStyle() => TextStyle(color: MyStyle().light);

  //Style
  TextStyle redStyle() => TextStyle(
        color: Colors.red.shade600,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      );

  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyStyle().primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );

//logo
  Widget showLogo() => Image(
        image: AssetImage('images/logo.png'),
      );

//image
  static String avatar = 'images/avatar.png';

  MyStyle();
}

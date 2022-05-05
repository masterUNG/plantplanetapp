// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantplanetapp/models/user_model.dart';
import 'package:plantplanetapp/router.dart';
import 'package:plantplanetapp/utility/my_constant.dart';
import 'package:plantplanetapp/utility/my_style.dart';

String initRoute = MyConstant.rountAuthen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        //login
        String uid = event.uid;

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .get()
            .then((value) {
          UserModel userModel = UserModel.fromMap(value.data()!);
          switch (userModel.typeUser) {
            case 'user':
              initRoute = MyConstant.rountServiceUser;
              runApp(const MyApp());
              break;
            case 'seller':
              initRoute = MyConstant.rountServiceSeller;
              runApp(const MyApp());
              break;
            default:
          }
        });
      } else {
        //logout
        runApp(const MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xff003d32, MyStyle.mapMaterialColor);
    return MaterialApp(
      routes: map,
      initialRoute: initRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantplanetapp/models/user_model.dart';
import 'package:plantplanetapp/router.dart';
import 'package:plantplanetapp/utility/my_style.dart';

String initRoute = '/authen';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        //login
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          UserModel model = UserModel.fromMap(event.data()!);
          switch (model.typeUser) {
            case 'user':
              initRoute = '/myServiceUser';
              runApp(MyApp());
              break;
            case 'seller':
              initRoute = '/myServiceSeller';
              runApp(MyApp());
              break;
            default:
              print('##### No Type User#####');
              initRoute = '/authen';
              runApp(MyApp());
              break;
          }
        });
      } else {
        //logout
        runApp(MyApp());
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

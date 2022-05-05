import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantplanetapp/bodys/show_product_user.dart';
import 'package:plantplanetapp/bodyuser/chatbot.dart';
import 'package:plantplanetapp/bodyuser/myorder_user.dart';
import 'package:plantplanetapp/bodyuser/shopping_bag_user.dart';
import 'package:plantplanetapp/models/plant_model.dart';
import 'package:plantplanetapp/models/user_model.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/my_signout.dart';
import 'package:plantplanetapp/widgets/show_icon_button.dart';
import 'package:plantplanetapp/widgets/show_title.dart';

class MyServiceUser extends StatefulWidget {
  @override
  State<MyServiceUser> createState() => _MyServiceUserState();
}

class _MyServiceUserState extends State<MyServiceUser> {
  List<Widget> widgets = [
    ShowProductUser(),
    ShoppingBagUser(),
    MyOrderUser(),
    ChatBotUser(),
  ];
  int indexWidget = 0;

  File? file;
  String? displayName;

  @override
  void initState() {
    super.initState();
    readMyProfile();
  }

  Future<void> readMyProfile() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      setState(() {
        displayName = event!.displayName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        actions: [
          ShowIconButton(
              iconData: Icons.camera,
              pressFunc: () async {
                var result = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  maxWidth: 800,
                  maxHeight: 800,
                );
                file = File(result!.path);
                //  เอาพภาพที่ได้ไปต่อยอด
                print('เอาพภาพที่ได้ไปต่อยอด ');
              })
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            MySignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(decoration: BoxDecoration(color: Colors.lime),
                    accountName: ShowTitle(
                        title: displayName ?? '',
                        textStyle: MyStyle().h2Style()),
                    accountEmail: null),
                menuShowProductUser(),
                menuShoppingBag(),
                menuMyOrder(),
                menuChatBot(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowProductUser() {
    return ListTile(
      onTap: (() {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      }),
      leading: const Icon(Icons.home_outlined),
      title: ShowTitle(title: 'List All Plant', textStyle: MyStyle().h2Style()),
    );
  }

  ListTile menuShoppingBag() {
    return ListTile(
      onTap: (() {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      }),
      leading: Icon(Icons.shopping_basket_outlined),
      title: ShowTitle(title: 'Shopping Bag', textStyle: MyStyle().h2Style()),
    );
  }

  ListTile menuMyOrder() {
    return ListTile(
      onTap: (() {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      }),
      leading: Icon(Icons.airport_shuttle_outlined),
      title: ShowTitle(title: 'My Order', textStyle: MyStyle().h2Style()),
    );
  }

  ListTile menuChatBot() {
    return ListTile(
      onTap: (() {
        setState(() {
          indexWidget = 3;
          Navigator.pop(context);
        });
      }),
      leading: Icon(Icons.add_reaction_outlined),
      title: ShowTitle(title: 'Chat Bot', textStyle: MyStyle().h2Style()),
    );
  }
}

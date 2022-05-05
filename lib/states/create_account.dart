import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantplanetapp/models/user_model.dart';
import 'package:plantplanetapp/utility/dialog.dart';
import 'package:plantplanetapp/utility/my_style.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late double screenWidth;
  String? typeUser, username, email, password;

  Container buildUsername() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.7,
      child: TextField(
        onChanged: (value) => username = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.perm_identity_outlined,
            color: MyStyle().dark,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Username',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().dark),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primary),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.7,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyStyle().dark,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Password',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().dark),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primary),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.7,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail_outline,
            color: MyStyle().dark,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Email',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().dark),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().primary),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: MyStyle().dark,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildLogo(),
              buildUsername(),
              buildEmail(),
              buildPassword(),
              buildTitle(),
              buildTypeUser(),
              buildTypeSeller(),
              buildCreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildCreateAccountButton() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      width: screenWidth * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyStyle().primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if ((username?.isEmpty ?? true) ||
              (email?.isEmpty ?? true) ||
              (password?.isEmpty ?? true)) {
            print('Have Space');
            normalDialog(context, 'Have Space ?', 'Please Fill In The Blank');
          } else if (typeUser == null) {
            normalDialog(context, 'No Type User ?', 'Please Choouse Type User');
          } else {
            createAccountAndInsertInformation();
          }
        },
        child: Text('Create Account'),
      ),
    );
  }

  Future<Null> createAccountAndInsertInformation() async {
    await Firebase.initializeApp().then((value) async {
      print(
          '##Firebase Initialize Success email ==>$email, password ==> $password##');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email as String, password: password as String)
          .then((value) async {
        print('Create Account Success');
        await value.user!
            .updateProfile(displayName: username)
            .then((value2) async {
          String uid = value.user!.uid;
          print('Update Profile Success and uid = $uid');

          UserModel model = UserModel(
              email: email as String,
              username: username as String,
              typeUser: typeUser as String);
          Map<String, dynamic> data = model.toMap();

          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .set(data)
              .then((value) {
            print('Insert Value To Firestore Success');
            switch (typeUser) {
              case 'user':
                Navigator.pushNamedAndRemoveUntil(
                    context, '/myServiceUser', (route) => false);
                break;
              case 'seller':
                Navigator.pushNamedAndRemoveUntil(
                    context, '/myServiceSeller', (route) => false);
                break;
              default:
            }
          });
        });
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));
    });
  }

  Container buildTypeUser() {
    return Container(
      width: screenWidth * 0.7,
      child: RadioListTile(
        value: 'user',
        groupValue: typeUser,
        onChanged: (value) {
          setState(() {
            typeUser = value as String;
          });
        },
        title: Text(
          'User',
          style: MyStyle().darkStyle(),
        ),
      ),
    );
  }

  Container buildTypeSeller() {
    return Container(
      width: screenWidth * 0.7,
      child: RadioListTile(
        value: 'seller',
        groupValue: typeUser,
        onChanged: (value) {
          setState(() {
            typeUser = value as String;
          });
        },
        title: Text(
          'Seller',
          style: MyStyle().darkStyle(),
        ),
      ),
    );
  }

  Container buildTitle() {
    return Container(
      width: screenWidth * 0.7,
      margin: EdgeInsets.only(top: 30),
      child: Text(
        'Type User',
        style: MyStyle().darkStyle(),
      ),
    );
  }

  Row buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth * 0.4,
          child: MyStyle().showLogo(),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantplanetapp/models/user_model.dart';
import 'package:plantplanetapp/utility/dialog.dart';
import 'package:plantplanetapp/utility/my_constant.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  late double screenWidth, screenHeight;
  bool redEye = true;
  String? username, password;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: ListView(
            children: [
              buildLogo(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildUser(),
                  buildPassword(),
                  buildSigninEmail(),
                  // buildSigninGoogle(),
                  // buildSigninFacebook(),

                  buildCreateAccount(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'Non Account ?',
          textStyle: MyStyle().lightStyle(),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/createAccount'),
          child: Text('Create Account'),
        ),
      ],
    );
  }

  Container buildSigninEmail() => Container(
        margin: const EdgeInsets.only(top: 30),
        child: SignInButton(
          Buttons.Email,
          onPressed: () {
            if ((username?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
              MyDialog(context: context).normalDialog(
                  title: 'Have Space ?', message: 'Please Fill Every Blank');
            } else {
              processCheckAuthen();
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  Container buildSigninGoogle() => Container(
        margin: EdgeInsets.only(top: 5),
        child: SignInButton(
          Buttons.GoogleDark,
          onPressed: () => processSignInWithGoogle(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  Future<Null> processSignInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    await Firebase.initializeApp().then((value) async {
      await _googleSignIn.signIn().then((value) {
        String? name = value!.displayName;
        String email = value.email;
        print(
            'Login With gmail Success value With name =$name, email = $email');
      });
    });
  }

  Container buildSigninFacebook() => Container(
        margin: EdgeInsets.only(top: 5),
        child: SignInButton(
          Buttons.Facebook,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  Container buildUser() {
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
        obscureText: redEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
            icon: Icon(
                redEye
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye_sharp,
                color: MyStyle().dark),
          ),
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

  Row buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 150),
          width: screenWidth * 0.4,
          child: MyStyle().showLogo(),
        ),
      ],
    );
  }

  Future<void> processCheckAuthen() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: username!, password: password!)
        .then((value) async {
      String uidLogin = value.user!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uidLogin)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        switch (userModel.typeUser) {
          case 'user':
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.rountServiceUser, (route) => false);
            break;
          case 'seller':
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.rountServiceSeller, (route) => false);
            break;
          default:
        }
      });
    }).catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, message: onError.message);
    });
  }
}

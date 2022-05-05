import 'package:flutter/material.dart';

class ShoppingBagUser extends StatefulWidget {
  const ShoppingBagUser({Key? key}) : super(key: key);

  @override
  State<ShoppingBagUser> createState() => _ShoppingBagUserState();
}

class _ShoppingBagUserState extends State<ShoppingBagUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This Is Show Product'),
    );
  }
}

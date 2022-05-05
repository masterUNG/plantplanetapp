import 'package:flutter/material.dart';
import 'package:plantplanetapp/bodys/add_product_seller.dart';
import 'package:plantplanetapp/states/authen.dart';
import 'package:plantplanetapp/states/create_account.dart';
import 'package:plantplanetapp/states/my_service_seller.dart';
import 'package:plantplanetapp/states/my_service_user.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/myServiceUser': (BuildContext context) => MyServiceUser(),
  '/myServiceSeller': (BuildContext context) => MyServiceSeller(),
  '/addProduct': (BuildContext context) => AddProductSeller(),
};

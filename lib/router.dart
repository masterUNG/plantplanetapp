import 'package:flutter/material.dart';
import 'package:plantplanetapp/bodys/add_product_seller.dart';
import 'package:plantplanetapp/states/authen.dart';
import 'package:plantplanetapp/states/create_account.dart';
import 'package:plantplanetapp/states/my_service_seller.dart';
import 'package:plantplanetapp/states/my_service_user.dart';
import 'package:plantplanetapp/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  MyConstant.rountAuthen: (BuildContext context) => const Authen(),
  MyConstant.rountCreateAccount: (BuildContext context) =>
      const CreateAccount(),
  MyConstant.rountServiceUser: (BuildContext context) => MyServiceUser(),
  MyConstant.rountServiceSeller: (BuildContext context) =>
      const MyServiceSeller(),
  MyConstant.rountAddProduct: (BuildContext context) =>
      const AddProductSeller(),
};

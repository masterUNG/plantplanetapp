import 'package:flutter/material.dart';
import 'package:plantplanetapp/bodys/add_product_seller.dart';
import 'package:plantplanetapp/bodys/show_order_seller.dart';
import 'package:plantplanetapp/bodys/show_product_seller.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/my_signout.dart';
import 'package:plantplanetapp/widgets/show_title.dart';

class MyServiceSeller extends StatefulWidget {
  const MyServiceSeller({Key? key}) : super(key: key);

  @override
  State<MyServiceSeller> createState() => _MyServiceSellerState();
}

class _MyServiceSellerState extends State<MyServiceSeller> {
  List<Widget> widgets = [
    const ShowOrderSeller(),
    const ShowProductSeller(),
    // AddProductSeller(),
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            const MySignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShowProduct(),
                // menuAddProduct(),
               
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.forest_outlined),
      title: ShowTitle(
        title: 'Your Plant',
        textStyle: MyStyle().h2Style(),
      ),
    );
  }

  ListTile menuAddProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.add_box_outlined),
      title: ShowTitle(
        title: 'Add Plant',
        textStyle: MyStyle().h2Style(),
      ),
    );
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: const Icon(Icons.airport_shuttle_outlined),
      title: ShowTitle(
        title: 'Your Order',
        textStyle: MyStyle().h2Style(),
      ),
    );
  }
}

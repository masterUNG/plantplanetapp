import 'package:flutter/material.dart';
import 'package:plantplanetapp/bodyuser/chatbot.dart';
import 'package:plantplanetapp/bodyuser/myorder_user.dart';
import 'package:plantplanetapp/bodyuser/shopping_bag_user.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/my_signout.dart';
import 'package:plantplanetapp/widgets/show_title.dart';

class MyServiceUser extends StatefulWidget {
  @override
  State<MyServiceUser> createState() => _MyServiceUserState();
}

class _MyServiceUserState extends State<MyServiceUser> {
  List<Widget> widgets = [
    ShoppingBagUser(),
    MyOrderUser(),
    ChatBotUser(),
  ];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            MySignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
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

  ListTile menuShoppingBag() {
    return ListTile(
      onTap: (() {
        setState(() {
          indexWidget = 0;
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
          indexWidget = 1;
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
          indexWidget = 2;
          Navigator.pop(context);
        });
      }),
      leading: Icon(Icons.add_reaction_outlined),
      title: ShowTitle(title: 'Chat Bot', textStyle: MyStyle().h2Style()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plantplanetapp/utility/my_style.dart';

class AddProductSeller extends StatefulWidget {
  const AddProductSeller({Key? key}) : super(key: key);

  @override
  State<AddProductSeller> createState() => _AddProductSellerState();
}

class _AddProductSellerState extends State<AddProductSeller> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildImage(constraints),
                    buildProductPrice(constraints),
                    addProductButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container addProductButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8,
      child: ElevatedButton(
        style: MyStyle().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {}
        },
        child: Text('Add Plant'),
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.75,
          child: Image.asset(MyStyle.avatar),
        ),
      ],
    );
  }
}

Widget buildProductPrice(BoxConstraints constraints) {
  return Container(
    width: constraints.maxWidth * 0.75,
    margin: EdgeInsets.only(top: 16),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Fill Price In The Blank';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelStyle: MyStyle().h3Style(),
        labelText: 'Price',
        prefixIcon: Icon(
          Icons.money,
          color: MyStyle().dark,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyStyle().dark),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyStyle().light),
          borderRadius: BorderRadius.circular(30),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}

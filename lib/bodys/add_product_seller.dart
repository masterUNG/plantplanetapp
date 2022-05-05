import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantplanetapp/models/nameplant_model.dart';
import 'package:plantplanetapp/models/plant_model.dart';
import 'package:plantplanetapp/utility/dialog.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/show_icon_button.dart';

class AddProductSeller extends StatefulWidget {
  const AddProductSeller({Key? key}) : super(key: key);

  @override
  State<AddProductSeller> createState() => _AddProductSellerState();
}

class _AddProductSellerState extends State<AddProductSeller> {
  final formKey = GlobalKey<FormState>();
  File? file;
  bool load = true;
  var namePlants = <String>[];
  String? namePlant, priceStr;

  @override
  void initState() {
    super.initState();
    readNamePlant();
  }

  Future<void> readNamePlant() async {
    await FirebaseFirestore.instance
        .collection('nameplant')
        .get()
        .then((value) {
      for (var item in value.docs) {
        NamePlantModel namePlantModel = NamePlantModel.fromMap(item.data());
        namePlants.add(namePlantModel.name);
      }

      load = false;
      setState(() {});
    });
  }

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
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildImage(constraints),
                      load ? const SizedBox() : buildNameDropdown(),
                      buildProductPrice(constraints),
                      addProductButton(constraints),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameDropdown() => DropdownButton<dynamic>(
      items: namePlants
          .map(
            (e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ),
          )
          .toList(),
      value: namePlant,
      hint: const Text('Please Choose Name Plant'),
      onChanged: (value) {
        setState(() {
          namePlant = value;
        });
      });

  Widget addProductButton(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.8,
      child: ElevatedButton(
        style: MyStyle().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            if (file == null) {
              MyDialog(context: context).normalDialog(
                  title: 'No Image', message: 'Please Take Photo');
            } else if (namePlant?.isEmpty ?? true) {
              MyDialog(context: context).normalDialog(
                  title: 'No NamePlant', message: 'Please Drop NamePlant');
            } else {}
            processUploadAndInsertData();
          }
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
          child: Stack(
            children: [
              file == null
                  ? Image.asset(
                      MyStyle.avatar,
                      fit: BoxFit.cover,
                    )
                  : Image.file(file!),
              Positioned(
                left: 0,
                bottom: 0,
                child: ShowIconButton(
                  iconData: Icons.add_a_photo,
                  pressFunc: () {
                    processTakePhoto(source: ImageSource.camera);
                  },
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: ShowIconButton(
                  iconData: Icons.add_photo_alternate,
                  pressFunc: () {
                    processTakePhoto(source: ImageSource.gallery);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> processTakePhoto({required ImageSource source}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result!.path);
    setState(() {});
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: const EdgeInsets.only(top: 16),
      child: TextFormField(
        onSaved: (newValue) => priceStr = newValue!.trim(),
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

  Future<void> processUploadAndInsertData() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uidLogin = event!.uid;
      DateTime dateTime = DateTime.now();

      String nameFile = '$uidLogin${Random().nextInt(100000)}.jpg';
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      Reference reference = firebaseStorage.ref().child('plant/$nameFile');
      UploadTask uploadTask = reference.putFile(file!);
      await uploadTask.whenComplete(() async {
        await reference.getDownloadURL().then((value) async {
          String urlImage = value;
          print(
              'namePlant ==>> $namePlant, priceStr ==>> $priceStr, uidLogin = $uidLogin, urlImage ==> $urlImage');

          PlantModel plantModel = PlantModel(
              nameplant: namePlant!,
              price: int.parse(priceStr!),
              timeAdd: Timestamp.fromDate(dateTime),
              uidAdd: uidLogin,
              urlImage: urlImage);

          await FirebaseFirestore.instance
              .collection('plant')
              .doc()
              .set(plantModel.toMap())
              .then((value) => Navigator.pop(context));
        });
      });
    });
  }
}

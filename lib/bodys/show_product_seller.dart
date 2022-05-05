import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantplanetapp/models/plant_model.dart';
import 'package:plantplanetapp/utility/my_constant.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/show_button.dart';
import 'package:plantplanetapp/widgets/show_progress.dart';
import 'package:plantplanetapp/widgets/show_title.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? havePlant;
  var plantModels = <PlantModel>[];

  @override
  void initState() {
    super.initState();
    readPlant();
  }

  Future<void> readPlant() async {
    if (plantModels.isNotEmpty) {
      plantModels.clear();
    }

    FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uidLogin = event!.uid;
      await FirebaseFirestore.instance
          .collection('plant')
          .where('uidAdd', isEqualTo: uidLogin)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          havePlant = true;

          for (var item in value.docs) {
            PlantModel plantModel = PlantModel.fromMap(item.data());
            plantModels.add(plantModel);
          }
        } else {
          havePlant = false;
        }

        load = false;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ShowButton(
        label: 'Add New Plant',
        pressFunc: () {
          Navigator.pushNamed(context, MyConstant.rountAddProduct)
              .then((value) {
            readPlant();
          });
        },
      ),
      body: load
          ? const ShowProgress()
          : havePlant!
              ? LayoutBuilder(builder: (context, constants) {
                  return listPlant(constants);
                })
              : Center(
                  child: ShowTitle(
                      title: 'No Plant !!!', textStyle: MyStyle().h1Style())),
    );
  }

  Widget listPlant(BoxConstraints constants) => ListView.builder(
        itemCount: plantModels.length,
        itemBuilder: (context, index) => Card(
          child: Row(
            children: [
              SizedBox(
                width: constants.maxWidth * 0.5 - 4,
                height: constants.maxWidth * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShowTitle(
                          title: plantModels[index].nameplant,
                          textStyle: MyStyle().h2Style()),
                      ShowTitle(
                          title: 'Price = ${plantModels[index].price} THB',
                          textStyle: MyStyle().h3Style()),
                      ShowTitle(
                          title:
                              'TimeAdd = ${plantModels[index].timeAdd.toDate().toString()}',
                          textStyle: MyStyle().h3Style()),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: constants.maxWidth * 0.5 - 4,
                height: constants.maxWidth * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    plantModels[index].urlImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

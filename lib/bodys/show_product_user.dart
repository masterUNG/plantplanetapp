import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantplanetapp/models/plant_model.dart';
import 'package:plantplanetapp/utility/my_style.dart';
import 'package:plantplanetapp/widgets/show_progress.dart';
import 'package:plantplanetapp/widgets/show_title.dart';

class ShowProductUser extends StatefulWidget {
  const ShowProductUser({Key? key}) : super(key: key);

  @override
  State<ShowProductUser> createState() => _ShowProductUserState();
}

class _ShowProductUserState extends State<ShowProductUser> {
  var plantModels = <PlantModel>[];
  bool load = true;

  @override
  void initState() {
    super.initState();
    readAllProduct();
  }

  Future<void> readAllProduct() async {
    if (plantModels.isNotEmpty) {
      plantModels.clear();
    }

    await FirebaseFirestore.instance.collection('plant').get().then((value) {
      for (var item in value.docs) {
        PlantModel plantModel = PlantModel.fromMap(item.data());
        plantModels.add(plantModel);
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load ? const ShowProgress() : gridAllPlant();
  }

  Widget gridAllPlant() => GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: plantModels.length,
        itemBuilder: (BuildContext context, int index) => InkWell(
          onTap: () {
            print('You tap ==> index = $index');
          },
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    plantModels[index].urlImage,
                    fit: BoxFit.cover,
                  ),
                ),
                ShowTitle(
                  title: plantModels[index].nameplant,
                  textStyle: MyStyle().h2Style(),
                ),
                ShowTitle(
                  title: '${plantModels[index].price} thb',
                  textStyle: MyStyle().h3Style(),
                ),
              ],
            ),
          ),
        ),
      );
}

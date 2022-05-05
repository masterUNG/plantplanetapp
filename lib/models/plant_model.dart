// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PlantModel {
  final String nameplant;
  final int price;
  final Timestamp timeAdd;
  final String uidAdd;
  final String urlImage;
  PlantModel({
    required this.nameplant,
    required this.price,
    required this.timeAdd,
    required this.uidAdd,
    required this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nameplant': nameplant,
      'price': price,
      'timeAdd': timeAdd,
      'uidAdd': uidAdd,
      'urlImage': urlImage,
    };
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      nameplant: (map['nameplant'] ?? '') as String,
      price: (map['price'] ?? 0) as int,
      timeAdd: (map['timeAdd']),
      uidAdd: (map['uidAdd'] ?? '') as String,
      urlImage: (map['urlImage'] ?? '') as String,
    );
  }

  factory PlantModel.fromJson(String source) => PlantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

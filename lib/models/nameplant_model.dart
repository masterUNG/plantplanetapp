import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NamePlantModel {
  final String name;
  final String color;
  NamePlantModel({
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'color': color,
    };
  }

  factory NamePlantModel.fromMap(Map<String, dynamic> map) {
    return NamePlantModel(
      name: (map['name'] ?? '') as String,
      color: (map['color'] ?? '') as String,
    );
  }

  factory NamePlantModel.fromJson(String source) => NamePlantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

// To parse this JSON data, do
//
//     final unitTypeModel = unitTypeModelFromJson(jsonString);

import 'dart:convert';

import 'package:smart_rent/data_layer/models/smart_model.dart';


List<UnitTypeModel> unitTypeModelFromJson(String str) =>
    List<UnitTypeModel>.from(
        json.decode(str).map((x) => UnitTypeModel.fromJson(x)));

String unitTypeModelToJson(List<UnitTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnitTypeModel extends SmartModel {
  int? id;
  String? code;
  String? name;
  String? description;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  UnitTypeModel({
    this.id,
    this.code,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory UnitTypeModel.fromJson(Map<String, dynamic> json) => UnitTypeModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return name!;
  }

  @override
  String getCode() {
    return '';
  }

}

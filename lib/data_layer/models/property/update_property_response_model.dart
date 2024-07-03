// To parse this JSON data, do
//
//     final updatePropertyResponseModel = updatePropertyResponseModelFromJson(jsonString);

import 'dart:convert';

UpdatePropertyResponseModel updatePropertyResponseModelFromJson(String str) => UpdatePropertyResponseModel.fromJson(json.decode(str));

String updatePropertyResponseModelToJson(UpdatePropertyResponseModel data) => json.encode(data.toJson());

class UpdatePropertyResponseModel {
  int? id;
  String? name;
  String? number;
  String? location;
  String? squareMeters;
  String? description;
  int? propertyTypeId;
  int? propertyCategoryId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  PropertyType? propertyType;

  UpdatePropertyResponseModel({
    this.id,
    this.name,
    this.number,
    this.location,
    this.squareMeters,
    this.description,
    this.propertyTypeId,
    this.propertyCategoryId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.propertyType,
  });

  factory UpdatePropertyResponseModel.fromJson(Map<String, dynamic> json) => UpdatePropertyResponseModel(
    id: json["id"],
    name: json["name"],
    number: json["number"],
    location: json["location"],
    squareMeters: json["square_meters"],
    description: json["description"],
    propertyTypeId: json["property_type_id"],
    propertyCategoryId: json["property_category_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    propertyType: json["property_type"] == null ? null : PropertyType.fromJson(json["property_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "number": number,
    "location": location,
    "square_meters": squareMeters,
    "description": description,
    "property_type_id": propertyTypeId,
    "property_category_id": propertyCategoryId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "property_type": propertyType?.toJson(),
  };
}

class PropertyType {
  int? id;
  String? code;
  String? name;
  String? description;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  PropertyType({
    this.id,
    this.code,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    description: json["description"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
}

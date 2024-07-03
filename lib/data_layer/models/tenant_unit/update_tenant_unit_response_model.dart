// To parse this JSON data, do
//
//     final updateTenantUnitResponseModel = updateTenantUnitResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateTenantUnitResponseModel updateTenantUnitResponseModelFromJson(String str) => UpdateTenantUnitResponseModel.fromJson(json.decode(str));

String updateTenantUnitResponseModelToJson(UpdateTenantUnitResponseModel data) => json.encode(data.toJson());

class UpdateTenantUnitResponseModel {
  String? message;

  UpdateTenantUnitResponseModel({
    this.message,
  });

  factory UpdateTenantUnitResponseModel.fromJson(Map<String, dynamic> json) => UpdateTenantUnitResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

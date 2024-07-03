// To parse this JSON data, do
//
//     final deleteTenantUnitResponseModel = deleteTenantUnitResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteTenantUnitResponseModel deleteTenantUnitResponseModelFromJson(String str) => DeleteTenantUnitResponseModel.fromJson(json.decode(str));

String deleteTenantUnitResponseModelToJson(DeleteTenantUnitResponseModel data) => json.encode(data.toJson());

class DeleteTenantUnitResponseModel {
  String? message;

  DeleteTenantUnitResponseModel({
    this.message,
  });

  factory DeleteTenantUnitResponseModel.fromJson(Map<String, dynamic> json) => DeleteTenantUnitResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

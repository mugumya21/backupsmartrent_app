// To parse this JSON data, do
//
//     final changePasswordResponseModel = changePasswordResponseModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordResponseModel changePasswordResponseModelFromJson(String str) => ChangePasswordResponseModel.fromJson(json.decode(str));

String changePasswordResponseModelToJson(ChangePasswordResponseModel data) => json.encode(data.toJson());

class ChangePasswordResponseModel {
  String? msg;

  ChangePasswordResponseModel({
    this.msg,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) => ChangePasswordResponseModel(
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
  };
}

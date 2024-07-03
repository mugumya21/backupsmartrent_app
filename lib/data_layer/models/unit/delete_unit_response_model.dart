// To parse this JSON data, do
//
//     final deleteUnitResponseModel = deleteUnitResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteUnitResponseModel deleteUnitResponseModelFromJson(String str) => DeleteUnitResponseModel.fromJson(json.decode(str));

String deleteUnitResponseModelToJson(DeleteUnitResponseModel data) => json.encode(data.toJson());

class DeleteUnitResponseModel {
  String? msg;

  DeleteUnitResponseModel({
    this.msg,
  });

  factory DeleteUnitResponseModel.fromJson(Map<String, dynamic> json) => DeleteUnitResponseModel(
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
  };
}

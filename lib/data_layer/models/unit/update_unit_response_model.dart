// To parse this JSON data, do
//
//     final updateUnitResponseModel = updateUnitResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateUnitResponseModel updateUnitResponseModelFromJson(String str) => UpdateUnitResponseModel.fromJson(json.decode(str));

String updateUnitResponseModelToJson(UpdateUnitResponseModel data) => json.encode(data.toJson());

class UpdateUnitResponseModel {
  String? msg;

  UpdateUnitResponseModel({
    this.msg,
  });

  factory UpdateUnitResponseModel.fromJson(Map<String, dynamic> json) => UpdateUnitResponseModel(
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
  };
}

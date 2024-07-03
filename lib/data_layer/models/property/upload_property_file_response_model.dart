// To parse this JSON data, do
//
//     final uploadPropertyFileResponseModel = uploadPropertyFileResponseModelFromJson(jsonString);

import 'dart:convert';

UploadPropertyFileResponseModel uploadPropertyFileResponseModelFromJson(String str) => UploadPropertyFileResponseModel.fromJson(json.decode(str));

String uploadPropertyFileResponseModelToJson(UploadPropertyFileResponseModel data) => json.encode(data.toJson());

class UploadPropertyFileResponseModel {
  String? message;

  UploadPropertyFileResponseModel({
    this.message,
  });

  factory UploadPropertyFileResponseModel.fromJson(Map<String, dynamic> json) => UploadPropertyFileResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

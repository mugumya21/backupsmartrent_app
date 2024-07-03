// To parse this JSON data, do
//
//     final uploadPaymentFileResponseModel = uploadPaymentFileResponseModelFromJson(jsonString);

import 'dart:convert';

UploadPaymentFileResponseModel uploadPaymentFileResponseModelFromJson(String str) => UploadPaymentFileResponseModel.fromJson(json.decode(str));

String uploadPaymentFileResponseModelToJson(UploadPaymentFileResponseModel data) => json.encode(data.toJson());

class UploadPaymentFileResponseModel {
  String? message;

  UploadPaymentFileResponseModel({
    this.message,
  });

  factory UploadPaymentFileResponseModel.fromJson(Map<String, dynamic> json) => UploadPaymentFileResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

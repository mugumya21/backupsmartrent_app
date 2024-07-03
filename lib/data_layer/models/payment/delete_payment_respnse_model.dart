// To parse this JSON data, do
//
//     final deletePaymentResponseModel = deletePaymentResponseModelFromJson(jsonString);

import 'dart:convert';

DeletePaymentResponseModel deletePaymentResponseModelFromJson(String str) => DeletePaymentResponseModel.fromJson(json.decode(str));

String deletePaymentResponseModelToJson(DeletePaymentResponseModel data) => json.encode(data.toJson());

class DeletePaymentResponseModel {
  String? message;

  DeletePaymentResponseModel({
    this.message,
  });

  factory DeletePaymentResponseModel.fromJson(Map<String, dynamic> json) => DeletePaymentResponseModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}

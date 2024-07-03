// To parse this JSON data, do
//
//     final uploadPropertyMainImageResponseModel = uploadPropertyMainImageResponseModelFromJson(jsonString);

import 'dart:convert';

UploadPropertyMainImageResponseModel uploadPropertyMainImageResponseModelFromJson(String str) => UploadPropertyMainImageResponseModel.fromJson(json.decode(str));

String uploadPropertyMainImageResponseModelToJson(UploadPropertyMainImageResponseModel data) => json.encode(data.toJson());

class UploadPropertyMainImageResponseModel {
  String? file;

  UploadPropertyMainImageResponseModel({
    this.file,
  });

  factory UploadPropertyMainImageResponseModel.fromJson(Map<String, dynamic> json) => UploadPropertyMainImageResponseModel(
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "file": file,
  };
}

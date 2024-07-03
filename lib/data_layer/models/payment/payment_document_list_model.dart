// To parse this JSON data, do
//
//     final paymentsDocumentsListModel = paymentsDocumentsListModelFromJson(jsonString);

import 'dart:convert';

List<PaymentsDocumentsListModel> paymentsDocumentsListModelFromJson(String str) => List<PaymentsDocumentsListModel>.from(json.decode(str).map((x) => PaymentsDocumentsListModel.fromJson(x)));

String paymentsDocumentsListModelToJson(List<PaymentsDocumentsListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentsDocumentsListModel {
  int? id;
  String? name;
  String? extension;
  String? nameOnFile;
  String? tempKey;
  int? externalKey;
  String? mimeType;
  int? size;
  dynamic isFeatured;
  dynamic description;
  int? documentTypeId;
  int? documentStatusId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentsDocumentsListModel({
    this.id,
    this.name,
    this.extension,
    this.nameOnFile,
    this.tempKey,
    this.externalKey,
    this.mimeType,
    this.size,
    this.isFeatured,
    this.description,
    this.documentTypeId,
    this.documentStatusId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentsDocumentsListModel.fromJson(Map<String, dynamic> json) => PaymentsDocumentsListModel(
    id: json["id"],
    name: json["name"],
    extension: json["extension"],
    nameOnFile: json["name_on_file"],
    tempKey: json["temp_key"],
    externalKey: json["external_key"],
    mimeType: json["mime_type"],
    size: json["size"],
    isFeatured: json["is_featured"],
    description: json["description"],
    documentTypeId: json["document_type_id"],
    documentStatusId: json["document_status_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "extension": extension,
    "name_on_file": nameOnFile,
    "temp_key": tempKey,
    "external_key": externalKey,
    "mime_type": mimeType,
    "size": size,
    "is_featured": isFeatured,
    "description": description,
    "document_type_id": documentTypeId,
    "document_status_id": documentStatusId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

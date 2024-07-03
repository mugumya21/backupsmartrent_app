// To parse this JSON data, do
//
//     final leaseReportModel = leaseReportModelFromJson(jsonString);

import 'dart:convert';

LeaseReportModel leaseReportModelFromJson(String str) => LeaseReportModel.fromJson(json.decode(str));

String leaseReportModelToJson(LeaseReportModel data) => json.encode(data.toJson());

class LeaseReportModel {
  List<Property>? properties;
  List<Tenantunit>? tenantunits;
  List<Client>? clients;
  Search? search;
  List<Unit>? units;

  LeaseReportModel({
    this.properties,
    this.tenantunits,
    this.clients,
    this.search,
    this.units,
  });

  factory LeaseReportModel.fromJson(Map<String, dynamic> json) => LeaseReportModel(
    properties: json["properties"] == null ? [] : List<Property>.from(json["properties"]!.map((x) => Property.fromJson(x))),
    tenantunits: json["tenantunits"] == null ? [] : List<Tenantunit>.from(json["tenantunits"]!.map((x) => Tenantunit.fromJson(x))),
    clients: json["clients"] == null ? [] : List<Client>.from(json["clients"]!.map((x) => Client.fromJson(x))),
    search: json["search"] == null ? null : Search.fromJson(json["search"]),
    units: json["units"] == null ? [] : List<Unit>.from(json["units"]!.map((x) => Unit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
    "tenantunits": tenantunits == null ? [] : List<dynamic>.from(tenantunits!.map((x) => x.toJson())),
    "clients": clients == null ? [] : List<dynamic>.from(clients!.map((x) => x.toJson())),
    "search": search?.toJson(),
    "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x.toJson())),
  };
}

class Client {
  int? id;
  String? number;
  int? clientTypeId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Client({
    this.id,
    this.number,
    this.clientTypeId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    number: json["number"],
    clientTypeId: json["client_type_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "number": number,
    "client_type_id": clientTypeId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Property {
  int? id;
  String? name;
  String? number;
  String? location;
  String? squareMeters;
  String? description;
  int? propertyTypeId;
  int? propertyCategoryId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Property({
    this.id,
    this.name,
    this.number,
    this.location,
    this.squareMeters,
    this.description,
    this.propertyTypeId,
    this.propertyCategoryId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    name: json["name"],
    number: json["number"],
    location: json["location"],
    squareMeters: json["square_meters"],
    description: json["description"],
    propertyTypeId: json["property_type_id"],
    propertyCategoryId: json["property_category_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "number": number,
    "location": location,
    "square_meters": squareMeters,
    "description": description,
    "property_type_id": propertyTypeId,
    "property_category_id": propertyCategoryId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}



class Search {
  String? propertyId;
  String? unitId;
  String? tenantId;
  String? tenantSelected;

  Search({
    this.propertyId,
    this.unitId,
    this.tenantId,
    this.tenantSelected,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    propertyId: json["property_id"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantSelected: json["tenant_selected"],
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "tenant_selected": tenantSelected,
  };
}

class Tenantunit {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? amount;
  int? convertedAmount;
  int? usdAmount;
  int? ugxAmount;
  int? discountAmount;
  int? convertedDiscountAmount;
  int? usdDiscountAmount;
  int? ugxDiscountAmount;
  int? duration;
  int? currencyId;
  String? description;
  int? unitId;
  int? tenantId;
  int? scheduleId;
  int? propertyId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Property? property;
  Unit? unit;

  Tenantunit({
    this.id,
    this.fromDate,
    this.toDate,
    this.amount,
    this.convertedAmount,
    this.usdAmount,
    this.ugxAmount,
    this.discountAmount,
    this.convertedDiscountAmount,
    this.usdDiscountAmount,
    this.ugxDiscountAmount,
    this.duration,
    this.currencyId,
    this.description,
    this.unitId,
    this.tenantId,
    this.scheduleId,
    this.propertyId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.property,
    this.unit,
  });

  factory Tenantunit.fromJson(Map<String, dynamic> json) => Tenantunit(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    amount: json["amount"],
    convertedAmount: json["converted_amount"],
    usdAmount: json["usd_amount"],
    ugxAmount: json["ugx_amount"],
    discountAmount: json["discount_amount"],
    convertedDiscountAmount: json["converted_discount_amount"],
    usdDiscountAmount: json["usd_discount_amount"],
    ugxDiscountAmount: json["ugx_discount_amount"],
    duration: json["duration"],
    currencyId: json["currency_id"],
    description: json["description"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    scheduleId: json["schedule_id"],
    propertyId: json["property_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    property: json["property"] == null ? null : Property.fromJson(json["property"]),
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "converted_amount": convertedAmount,
    "usd_amount": usdAmount,
    "ugx_amount": ugxAmount,
    "discount_amount": discountAmount,
    "converted_discount_amount": convertedDiscountAmount,
    "usd_discount_amount": usdDiscountAmount,
    "ugx_discount_amount": ugxDiscountAmount,
    "duration": duration,
    "currency_id": currencyId,
    "description": description,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "schedule_id": scheduleId,
    "property_id": propertyId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "property": property?.toJson(),
    "unit": unit?.toJson(),
  };
}

class Unit {
  int? id;
  String? name;
  int? amount;
  int? convertedAmount;
  int? usdAmount;
  int? ugxAmount;
  int? isAvailable;
  String? squareMeters;
  String? description;
  int? unitType;
  int? floorId;
  int? scheduleId;
  int? propertyId;
  int? currencyId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Unit({
    this.id,
    this.name,
    this.amount,
    this.convertedAmount,
    this.usdAmount,
    this.ugxAmount,
    this.isAvailable,
    this.squareMeters,
    this.description,
    this.unitType,
    this.floorId,
    this.scheduleId,
    this.propertyId,
    this.currencyId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    convertedAmount: json["converted_amount"],
    usdAmount: json["usd_amount"],
    ugxAmount: json["ugx_amount"],
    isAvailable: json["is_available"],
    squareMeters: json["square_meters"],
    description: json["description"],
    unitType: json["unit_type"],
    floorId: json["floor_id"],
    scheduleId: json["schedule_id"],
    propertyId: json["property_id"],
    currencyId: json["currency_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "converted_amount": convertedAmount,
    "usd_amount": usdAmount,
    "ugx_amount": ugxAmount,
    "is_available": isAvailable,
    "square_meters": squareMeters,
    "description": description,
    "unit_type": unitType,
    "floor_id": floorId,
    "schedule_id": scheduleId,
    "property_id": propertyId,
    "currency_id": currencyId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// To parse this JSON data, do
//
//     final unPaidReportModel = unPaidReportModelFromJson(jsonString);

import 'dart:convert';

import 'package:smart_rent/data_layer/models/payment/payment_schedules_model.dart';
import 'package:smart_rent/data_layer/models/smart_model.dart';
import 'package:smart_rent/data_layer/models/tenant/tenant_details_model.dart';
import 'package:smart_rent/data_layer/models/tenant_unit/tenant_unit_model.dart';
import 'package:smart_rent/data_layer/models/unit/unit_model.dart';

UnPaidReportModel unPaidReportModelFromJson(String str) => UnPaidReportModel.fromJson(json.decode(str));

String unPaidReportModelToJson(UnPaidReportModel data) => json.encode(data.toJson());

class UnPaidReportModel {
  List<PaymentSchedulesModel>? schedules;
  List<UnpaidProperty>? properties;
  List<TenantUnitModel>? tenantUnitModel;
  List<TenantProfile>? tenantProfileModel;
  UnPaidSearch? search;
  List<UnitModel>? unitModel;

  UnPaidReportModel({
    this.schedules,
    this.properties,
    this.tenantUnitModel,
    this.tenantProfileModel,
    this.search,
    this.unitModel,
  });

  factory UnPaidReportModel.fromJson(Map<String, dynamic> json) => UnPaidReportModel(
    schedules: json["schedules"] == null ? [] : List<PaymentSchedulesModel>.from(json["schedules"]!.map((x) => PaymentSchedulesModel.fromJson(x))),
    properties: json["properties"] == null ? [] : List<UnpaidProperty>.from(json["properties"]!.map((x) => UnpaidProperty.fromJson(x))),
    tenantUnitModel: json["tenantunits"] == null ? [] : List<TenantUnitModel>.from(json["tenantunits"]!.map((x) => TenantUnitModel.fromJson(x))),
    tenantProfileModel: json["clients"] == null ? [] : List<TenantProfile>.from(json["clients"]!.map((x) => TenantProfile.fromJson(x))),
    search: json["search"] == null ? null : UnPaidSearch.fromJson(json["search"]),
    unitModel: json["units"] == null ? [] : List<UnitModel>.from(json["units"]!.map((x) => UnitModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "schedules": schedules == null ? [] : List<dynamic>.from(schedules!.map((x) => x.toJson())),
    "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
    "tenantunits": tenantUnitModel == null ? [] : List<dynamic>.from(tenantUnitModel!.map((x) => x.toJson())),
    "clients": tenantProfileModel == null ? [] : List<dynamic>.from(tenantProfileModel!.map((x) => x.toJson())),
    "search": search?.toJson(),
    "units": unitModel == null ? [] : List<dynamic>.from(unitModel!.map((x) => x.toJson())),
  };
}

class Client {
  int? id;
  Number? number;
  int? clientTypeId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ClientProfile>? clientProfiles;

  Client({
    this.id,
    this.number,
    this.clientTypeId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.clientProfiles,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    number: numberValues.map[json["number"]]!,
    clientTypeId: json["client_type_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    clientProfiles: json["client_profiles"] == null ? [] : List<ClientProfile>.from(json["client_profiles"]!.map((x) => ClientProfile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "number": numberValues.reverse[number],
    "client_type_id": clientTypeId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "client_profiles": clientProfiles == null ? [] : List<dynamic>.from(clientProfiles!.map((x) => x.toJson())),
  };
}

class ClientProfile {
  int? id;
  Name? firstName;
  dynamic middleName;
  LastName? lastName;
  Name? companyName;
  DateTime? dateOfBirth;
  int? gender;
  Address? address;
  String? tin;
  String? number;
  dynamic email;
  String? nin;
  dynamic designation;
  dynamic description;
  int? clientId;
  int? nationId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  ClientProfile({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.companyName,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.tin,
    this.number,
    this.email,
    this.nin,
    this.designation,
    this.description,
    this.clientId,
    this.nationId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) => ClientProfile(
    id: json["id"],
    firstName: nameValues.map[json["first_name"]]!,
    middleName: json["middle_name"],
    lastName: lastNameValues.map[json["last_name"]]!,
    companyName: nameValues.map[json["company_name"]]!,
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    gender: json["gender"],
    address: addressValues.map[json["address"]]!,
    tin: json["tin"],
    number: json["number"],
    email: json["email"],
    nin: json["nin"],
    designation: json["designation"],
    description: json["description"],
    clientId: json["client_id"],
    nationId: json["nation_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": nameValues.reverse[firstName],
    "middle_name": middleName,
    "last_name": lastNameValues.reverse[lastName],
    "company_name": nameValues.reverse[companyName],
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "address": addressValues.reverse[address],
    "tin": tin,
    "number": number,
    "email": email,
    "nin": nin,
    "designation": designation,
    "description": description,
    "client_id": clientId,
    "nation_id": nationId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Address {
  HFBBFHFH,
  NAKAWA,
  NTINDA
}

final addressValues = EnumValues({
  "hfbbfhfh": Address.HFBBFHFH,
  "NAKAWA": Address.NAKAWA,
  "NTINDA": Address.NTINDA
});

enum Name {
  ASHLEY,
  GAJU_COLLECTIONS,
  JP_HOLDINGS
}

final nameValues = EnumValues({
  "ASHLEY": Name.ASHLEY,
  "GAJU COLLECTIONS": Name.GAJU_COLLECTIONS,
  "JP Holdings": Name.JP_HOLDINGS
});

enum LastName {
  AISHA
}

final lastNameValues = EnumValues({
  "AISHA": LastName.AISHA
});

enum Number {
  C_20240207071834,
  C_20240207081944,
  C_20240220112355
}

final numberValues = EnumValues({
  "C-20240207071834": Number.C_20240207071834,
  "C-20240207081944": Number.C_20240207081944,
  "C-20240220112355": Number.C_20240220112355
});

class UnpaidProperty extends SmartPropertyModel {
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

  UnpaidProperty({
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

  factory UnpaidProperty.fromJson(Map<String, dynamic> json) => UnpaidProperty(
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

  @override
  int getCategoryTypeId() {
    return propertyCategoryId!;
  }

  @override
  String getDescription() {
    return description!;
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getImageDocUrl() {
    return '';
  }

  @override
  String getLocation() {
    return location!;
  }

  @override
  int getMainImage() {
    return 0;
  }

  @override
  String getName() {
    return name!;
  }

  @override
  String getNumber() {
    return number!;
  }

  @override
  int getOrganisationId() {
    return 0;
  }

  @override
  int getPropertyTypeId() {
    return propertyTypeId!;
  }

  @override
  String getSquareMeters() {
    return squareMeters!;
  }

  @override
  String getPropertyCategoryName() {
    return '';
  }
}

class Schedule {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? discountAmount;
  int? paid;
  int? balance;
  int? balanceCForward;
  String? description;
  int? unitId;
  int? tenantId;
  int? tenantUnitId;
  int? scheduleId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Tenantunit? tenantunit;
  Unit? unit;

  Schedule({
    this.id,
    this.fromDate,
    this.toDate,
    this.discountAmount,
    this.paid,
    this.balance,
    this.balanceCForward,
    this.description,
    this.unitId,
    this.tenantId,
    this.tenantUnitId,
    this.scheduleId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.tenantunit,
    this.unit,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    discountAmount: json["discount_amount"],
    paid: json["paid"],
    balance: json["balance"],
    balanceCForward: json["balance_c_forward"],
    description: json["description"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantUnitId: json["tenant_unit_id"],
    scheduleId: json["schedule_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    tenantunit: json["tenantunit"] == null ? null : Tenantunit.fromJson(json["tenantunit"]),
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "discount_amount": discountAmount,
    "paid": paid,
    "balance": balance,
    "balance_c_forward": balanceCForward,
    "description": description,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "tenant_unit_id": tenantUnitId,
    "schedule_id": scheduleId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "tenantunit": tenantunit?.toJson(),
    "unit": unit?.toJson(),
  };
}

class Tenantunit {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? amount;
  int? duration;
  int? discountAmount;
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
  Client? tenant;

  Tenantunit({
    this.id,
    this.fromDate,
    this.toDate,
    this.amount,
    this.duration,
    this.discountAmount,
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
    this.tenant,
  });

  factory Tenantunit.fromJson(Map<String, dynamic> json) => Tenantunit(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    amount: json["amount"],
    duration: json["duration"],
    discountAmount: json["discount_amount"],
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
    tenant: json["tenant"] == null ? null : Client.fromJson(json["tenant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "duration": duration,
    "discount_amount": discountAmount,
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
    "tenant": tenant?.toJson(),
  };
}

class Unit {
  int? id;
  String? name;
  int? amount;
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

class UnPaidSearch {
  String? propertyId;
  String? from;
  String? to;
  String? unitId;
  String? tenantId;
  String? tenantSelected;
  String? periodDate;
  DateTime? thismonth;
  DateTime? lastmonth;
  List<DateTime>? dates;

  UnPaidSearch({
    this.propertyId,
    this.from,
    this.to,
    this.unitId,
    this.tenantId,
    this.tenantSelected,
    this.periodDate,
    this.thismonth,
    this.lastmonth,
    this.dates,
  });

  factory UnPaidSearch.fromJson(Map<String, dynamic> json) => UnPaidSearch(
    propertyId: json["property_id"],
    from: json["from"],
    to: json["to"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantSelected: json["tenant_selected"],
    periodDate: json["period_date"],
    thismonth: json["thismonth"] == null ? null : DateTime.parse(json["thismonth"]),
    lastmonth: json["lastmonth"] == null ? null : DateTime.parse(json["lastmonth"]),
    dates: json["dates"] == null ? [] : List<DateTime>.from(json["dates"]!.map((x) => DateTime.parse(x))),
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "from": from,
    "to": to,
    "unit_id": unitId,
    "tenant_id": tenantId,
    "tenant_selected": tenantSelected,
    "period_date": periodDate,
    "thismonth": "${thismonth!.year.toString().padLeft(4, '0')}-${thismonth!.month.toString().padLeft(2, '0')}-${thismonth!.day.toString().padLeft(2, '0')}",
    "lastmonth": "${lastmonth!.year.toString().padLeft(4, '0')}-${lastmonth!.month.toString().padLeft(2, '0')}-${lastmonth!.day.toString().padLeft(2, '0')}",
    "dates": dates == null ? [] : List<dynamic>.from(dates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
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

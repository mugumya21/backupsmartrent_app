// To parse this JSON data, do
//
//     final collectionsReportResponseModel = collectionsReportResponseModelFromJson(jsonString);

import 'dart:convert';

CollectionsReportResponseModel collectionsReportResponseModelFromJson(String str) => CollectionsReportResponseModel.fromJson(json.decode(str));

String collectionsReportResponseModelToJson(CollectionsReportResponseModel data) => json.encode(data.toJson());

class CollectionsReportResponseModel {
  List<CollectionsReportModel>? schedules;
  List<Unit>? vacantunits;
  Search? search;

  CollectionsReportResponseModel({
    this.schedules,
    this.vacantunits,
    this.search,
  });

  factory CollectionsReportResponseModel.fromJson(Map<String, dynamic> json) => CollectionsReportResponseModel(
    schedules: json["schedules"] == null ? [] : List<CollectionsReportModel>.from(json["schedules"]!.map((x) => CollectionsReportModel.fromJson(x))),
    vacantunits: json["vacantunits"] == null ? [] : List<Unit>.from(json["vacantunits"]!.map((x) => Unit.fromJson(x))),
    search: json["search"] == null ? null : Search.fromJson(json["search"]),
  );

  Map<String, dynamic> toJson() => {
    "schedules": schedules == null ? [] : List<dynamic>.from(schedules!.map((x) => x.toJson())),
    "vacantunits": vacantunits == null ? [] : List<dynamic>.from(vacantunits!.map((x) => x.toJson())),
    "search": search?.toJson(),
  };
}

class CollectionsReportModel {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? discountAmount;
  int? paid;
  int? balance;
  int? balanceCForward;
  ScheduleDescription? description;
  int? unitId;
  int? tenantId;
  int? tenantUnitId;
  int? scheduleId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Tenantunit? tenantunit;
  int? foreignDiscountAmount;
  int? baseDiscountAmount;
  int? foreignPaid;
  int? basePaid;
  int? foreignBalance;
  int? baseBalance;

  CollectionsReportModel({
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
    this.foreignDiscountAmount,
    this.baseDiscountAmount,
    this.foreignPaid,
    this.basePaid,
    this.foreignBalance,
    this.baseBalance,
  });

  factory CollectionsReportModel.fromJson(Map<String, dynamic> json) => CollectionsReportModel(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    discountAmount: json["discount_amount"],
    paid: json["paid"],
    balance: json["balance"],
    balanceCForward: json["balance_c_forward"],
    description: scheduleDescriptionValues.map[json["description"]],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantUnitId: json["tenant_unit_id"],
    scheduleId: json["schedule_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    tenantunit: json["tenantunit"] == null ? null : Tenantunit.fromJson(json["tenantunit"]),
    foreignDiscountAmount: json["foreign_discount_amount"],
    baseDiscountAmount: json["base_discount_amount"],
    foreignPaid: json["foreign_paid"],
    basePaid: json["base_paid"],
    foreignBalance: json["foreign_balance"],
    baseBalance: json["base_balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "discount_amount": discountAmount,
    "paid": paid,
    "balance": balance,
    "balance_c_forward": balanceCForward,
    "description": scheduleDescriptionValues.reverse[description],
    "unit_id": unitId,
    "tenant_id": tenantId,
    "tenant_unit_id": tenantUnitId,
    "schedule_id": scheduleId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "tenantunit": tenantunit?.toJson(),
    "foreign_discount_amount": foreignDiscountAmount,
    "base_discount_amount": baseDiscountAmount,
    "foreign_paid": foreignPaid,
    "base_paid": basePaid,
    "foreign_balance": foreignBalance,
    "base_balance": baseBalance,
  };
}

enum ScheduleDescription {
  A_TENANT_UNIT_CREATED_BY_MC_JONATHAN,
  DESCRIPTION_TO_LET,
  MARK_TEST_POST,
  TEST1,
  TEST_DESCRIPTION,
  TEST_LOADING,
  TEST_POST,
  TEST_POST_TODAY,
  TEST_TENANT_UNIT,
  TFJFYGG,
  TO_LET,
  V_V_HAHHAHHSS
}

final scheduleDescriptionValues = EnumValues({
  "A tenant unit created by Mc'Jonathan": ScheduleDescription.A_TENANT_UNIT_CREATED_BY_MC_JONATHAN,
  "TO LET": ScheduleDescription.DESCRIPTION_TO_LET,
  "Mark test post": ScheduleDescription.MARK_TEST_POST,
  "TEST1": ScheduleDescription.TEST1,
  "Test description": ScheduleDescription.TEST_DESCRIPTION,
  "Test loading": ScheduleDescription.TEST_LOADING,
  "Test post": ScheduleDescription.TEST_POST,
  "Test post today": ScheduleDescription.TEST_POST_TODAY,
  "Test tenant unit": ScheduleDescription.TEST_TENANT_UNIT,
  "tfjfygg": ScheduleDescription.TFJFYGG,
  "to let": ScheduleDescription.TO_LET,
  "vVHahhahhss": ScheduleDescription.V_V_HAHHAHHSS
});

class Tenantunit {
  int? id;
  DateTime? fromDate;
  DateTime? toDate;
  int? amount;
  int? duration;
  int? discountAmount;
  int? currencyId;
  ScheduleDescription? description;
  int? unitId;
  int? tenantId;
  int? scheduleId;
  int? propertyId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Unit? unit;
  Tenant? tenant;
  int? convertedAmount;
  // int? usdAmount;
  // int? ugxAmount;
  // int? convertedDiscountAmount;
  // int? usdDiscountAmount;
  // int? ugxDiscountAmount;
  int? foreignAmount;
  int? baseAmount;
  int? convertedDiscountAmount;
  int? foreignDiscountAmount;
  int? baseDiscountAmount;

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
    this.unit,
    this.tenant,
    this.convertedAmount,
    // this.usdAmount,
    // this.ugxAmount,
    // this.convertedDiscountAmount,
    // this.usdDiscountAmount,
    // this.ugxDiscountAmount,
    this.foreignAmount,
    this.baseAmount,
    this.convertedDiscountAmount,
    this.foreignDiscountAmount,
    this.baseDiscountAmount,

  });

  factory Tenantunit.fromJson(Map<String, dynamic> json) => Tenantunit(
    id: json["id"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    amount: json["amount"],
    duration: json["duration"],
    discountAmount: json["discount_amount"],
    currencyId: json["currency_id"],
    description: scheduleDescriptionValues.map[json["description"]],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    scheduleId: json["schedule_id"],
    propertyId: json["property_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
    tenant: json["tenant"] == null ? null : Tenant.fromJson(json["tenant"]),
    convertedAmount: json["converted_amount"],
    // usdAmount: json["usd_amount"],
    // ugxAmount: json["ugx_amount"],
    // convertedDiscountAmount: json["converted_discount_amount"],
    // usdDiscountAmount: json["usd_discount_amount"],
    // ugxDiscountAmount: json["ugx_discount_amount"],
    foreignAmount: json["foreign_amount"],
    baseAmount: json["base_amount"],
    convertedDiscountAmount: json["converted_discount_amount"],
    foreignDiscountAmount: json["foreign_discount_amount"],
    baseDiscountAmount: json["base_discount_amount"],


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "duration": duration,
    "discount_amount": discountAmount,
    "currency_id": currencyId,
    "description": scheduleDescriptionValues.reverse[description],
    "unit_id": unitId,
    "tenant_id": tenantId,
    "schedule_id": scheduleId,
    "property_id": propertyId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "unit": unit?.toJson(),
    "tenant": tenant?.toJson(),
    "converted_amount": convertedAmount,
    // "usd_amount": usdAmount,
    // "ugx_amount": ugxAmount,
    // "converted_discount_amount": convertedDiscountAmount,
    // "usd_discount_amount": usdDiscountAmount,
    // "ugx_discount_amount": ugxDiscountAmount,
    "foreign_amount": foreignAmount,
    "base_amount": baseAmount,
    "converted_discount_amount": convertedDiscountAmount,
    "foreign_discount_amount": foreignDiscountAmount,
    "base_discount_amount": baseDiscountAmount,
  };
}

class Tenant {
  int? id;
  Number? number;
  int? clientTypeId;
  int? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ClientProfile>? clientProfiles;

  Tenant({
    this.id,
    this.number,
    this.clientTypeId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.clientProfiles,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    id: json["id"],
    number: numberValues.map[json["number"]],
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
  String? firstName;
  dynamic middleName;
  String? lastName;
  String? companyName;
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
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    companyName: json["company_name"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    gender: json["gender"],
    address: addressValues.map[json["address"]],
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
  int? convertedAmount;
  // int? usdAmount;
  // int? ugxAmount;
  int? foreignAmount;
  int? baseAmount;

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
    this.convertedAmount,
    // this.usdAmount,
    // this.ugxAmount,
    this.foreignAmount,
    this.baseAmount,
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
    convertedAmount: json["converted_amount"],
    // usdAmount: json["usd_amount"],
    // ugxAmount: json["ugx_amount"],
    foreignAmount: json["foreign_amount"],
    baseAmount: json["base_amount"],
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
    "converted_amount": convertedAmount,
    // "usd_amount": usdAmount,
    // "ugx_amount": ugxAmount,
    "foreign_amount": foreignAmount,
    "base_amount": baseAmount,
  };
}

// enum UnitDescription {
//   DESCRIPTION_TO_LET,
//   DFD,
//   TATFAYAGHAHAVAV,
//   TEST,
//   TEST1,
//   TEST2,
//   TEST_POST_TO_REFRESH_AFTER_POSTING,
//   TEST_UNIT,
//   TO_LET,
//   TSTT,
//   UNIT1,
//   UNIT_ROOM_ON_A_FLOOR_CREATED_BY_MC_JONATHAN,
//   VINCE_FLOOR,
//   YFAGGAJJSGGS
// }
//
// final unitDescriptionValues = EnumValues({
//   "TO LET": UnitDescription.DESCRIPTION_TO_LET,
//   "dfd": UnitDescription.DFD,
//   "tatfayaghahavav": UnitDescription.TATFAYAGHAHAVAV,
//   "TEST": UnitDescription.TEST,
//   "TEST1": UnitDescription.TEST1,
//   "TEST2": UnitDescription.TEST2,
//   "Test post to refresh after posting": UnitDescription.TEST_POST_TO_REFRESH_AFTER_POSTING,
//   "Test unit": UnitDescription.TEST_UNIT,
//   "to let": UnitDescription.TO_LET,
//   "TSTT": UnitDescription.TSTT,
//   "unit1": UnitDescription.UNIT1,
//   "Unit room on a floor created by Mc'Jonathan.": UnitDescription.UNIT_ROOM_ON_A_FLOOR_CREATED_BY_MC_JONATHAN,
//   "Vince floor": UnitDescription.VINCE_FLOOR,
//   "yfaggajjsggs": UnitDescription.YFAGGAJJSGGS
// });

class Search {
  String? propertyId;
  String? from;
  String? to;
  String? unitId;
  String? tenantId;
  String? tenantSelected;
  DateTime? periodDate;
  DateTime? thismonth;
  DateTime? lastmonth;
  List<DateTime>? dates;

  Search({
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

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    propertyId: json["property_id"],
    from: json["from"],
    to: json["to"],
    unitId: json["unit_id"],
    tenantId: json["tenant_id"],
    tenantSelected: json["tenant_selected"],
    periodDate: json["period_date"] == null ? null : DateTime.parse(json["period_date"]),
    // thismonth: json["thismonth"] == null
    //     ? null
    //     : DateTime.parse(json["thismonth"]),
    // lastmonth: json["lastmonth"] == null
    //     ? null
    //     : DateTime.parse(json["lastmonth"]),
    // dates: json["dates"] == null
    //     ? []
    //     : [
    //   if (json["thismonth"] != null)
    //     DateTime.parse(json["thismonth"]),
    //   if (json["lastmonth"] != null)
    //     DateTime.parse(json["lastmonth"]),
    //   ...List<DateTime>.from(json["dates"].map((x) => DateTime.parse(x))),
    // ],
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
    "period_date": "${periodDate!.year.toString().padLeft(4, '0')}-${periodDate!.month.toString().padLeft(2, '0')}-${periodDate!.day.toString().padLeft(2, '0')}",
    // "thismonth": thismonth == null
    //     ? null
    //     : "${thismonth!.year.toString().padLeft(4, '0')}-${thismonth!.month.toString().padLeft(2, '0')}-${thismonth!.day.toString().padLeft(2, '0')}",
    // "lastmonth": lastmonth == null
    //     ? null
    //     : "${lastmonth!.year.toString().padLeft(4, '0')}-${lastmonth!.month.toString().padLeft(2, '0')}-${lastmonth!.day.toString().padLeft(2, '0')}",
    // "dates": dates == null
    //     ? []
    //     : [
    //   if (thismonth != null)
    //     "${thismonth!.year.toString().padLeft(4, '0')}-${thismonth!.month.toString().padLeft(2, '0')}-${thismonth!.day.toString().padLeft(2, '0')}",
    //   if (lastmonth != null)
    //     "${lastmonth!.year.toString().padLeft(4, '0')}-${lastmonth!.month.toString().padLeft(2, '0')}-${lastmonth!.day.toString().padLeft(2, '0')}",
    //   ...dates!.map((x) => "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}"),
    // ],
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

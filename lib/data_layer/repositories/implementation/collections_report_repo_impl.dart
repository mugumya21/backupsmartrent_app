import 'dart:convert';
import 'dart:io';

import 'package:smart_rent/configs/app_configs.dart';

import 'package:smart_rent/data_layer/models/reports/collections/collections_report_model.dart';
// import 'package:smart_rent/data_layer/models/reports/unpaid/unpaid_reports_model.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/collections_report_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';


class CollectionsReportRepoImpl implements CollectionsReportRepo {
  // @override
  // Future<List<CollectionsReportModel>> getCollectionsReport(
  //     String token, int? propertyId, String? periodDate) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     var headers = {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.acceptHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: 'Bearer $token'
  //     };
  //
  //     // var url = Uri.parse('$appUrl/api/reports/collectionsreport');
  //     var url = Uri.parse('$appUrl/api/reports/collectionsreport?form-submit=&property_id=$propertyId&period_date=$periodDate');
  //
  //     var response = await client.get(url, headers: headers);
  //     List collectionsData = jsonDecode(response.body)['schedules'];
  //     if (kDebugMode) {
  //       print("collections Report RESPONSE: $response");
  //       print("collections Report RESPONSE: ${response.body}");
  //     }
  //     List<CollectionsReportModel> collectionsList = collectionsData
  //         .map((nation) => CollectionsReportModel.fromJson(nation))
  //         .toList();
  //
  //     collectionsList.sort((a, b) => b.balance!.compareTo(a.balance!));
  //
  //     return collectionsList;
  //
  //     // return collectionsData
  //     //     .map((nation) => CollectionsReportModel.fromJson(nation))
  //     //     .toList();
  //     return [];
  //   } finally {
  //     client.close();
  //   }
  // }

  @override
  Future<List<CollectionsReportModel>> getCollectionsReport(
      String token, int? propertyId, String? periodDate, int? currencyId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      // var url = Uri.parse('$appUrl/api/reports/collectionsreport');
      // var url = Uri.parse('$appUrl/api/reports/collectionsreport?form-submit=&property_id=$propertyId&period_date=$periodDate&currency_id=$currencyId');
      var url = Uri.parse('$appUrl/api/reports/collectionsreport?property_id=$propertyId&period_date=$periodDate&currency_id=$currencyId&form-submit=');

      var response = await client.get(url, headers: headers);
      List collectionsData = jsonDecode(response.body)['schedules'];
      List vacantData = jsonDecode(response.body)['vacantunits'];
      if (kDebugMode) {
        print("collections Report RESPONSE: $response");
        print("collections Report RESPONSE: ${response.body}");
      }
      List<CollectionsReportModel> collectionsList = collectionsData
          .map((nation) => CollectionsReportModel.fromJson(nation))
          .toList();

      // Convert vacantData to CollectionsReportModel list
      List<CollectionsReportModel> vacantList = vacantData
          .map((unit) => convertToCollectionsReportModel(Unit.fromJson(unit)))
          .toList();
      // List<CollectionsReportModel> vacantList =  vacantData.map((vacant) => CollectionsReportModel()).toList();
      collectionsList.addAll(vacantList);
      // collectionsList.sort((a, b) => b.balance!.compareTo(a.balance!));

      collectionsList.sort((a, b) {
        if (a.baseBalance != null && b.baseBalance != null) {
          return b.baseBalance!.compareTo(a.baseBalance!);
        } else if (a.baseBalance == null && b.baseBalance == null) {
          return 0; // Both balances are null, consider them equal
        } else if (a.baseBalance == null) {
          return 1; // Treat null as greater than any non-null value
        } else {
          return -1; // Treat non-null as less than null
        }
      });


      return collectionsList;

      // return collectionsData
      //     .map((nation) => CollectionsReportModel.fromJson(nation))
      //     .toList();
      return [];
    } finally {
      client.close();
    }
  }



  @override
  Future<List<dynamic>> getCollectionsDates(String token) async {
    var client = RetryClient(http.Client());


    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/reports/collectionsreport');

      var response = await client.get(url, headers: headers);
      List<dynamic> collectionsDatesData = jsonDecode(response.body)['search']['dates'];
      // print('my response $response');
      print('my url $url');
      if (kDebugMode) {
        print("collections dates RESPONSE: $response");
        print("collections dates RESPONSE: ${response.body}");
      }

      // Convert the dynamic list of date strings to DateTime objects
      List<DateTime> dates = collectionsDatesData
          .map((dateString) => DateTime.parse(dateString))
          .toList();

      // Add today's date
      DateTime today = DateTime.now();
      dates.insert(0, today);

      // Add the date a month ago
      DateTime aMonthAgo = DateTime.now().subtract(Duration(days: 30));
      dates.insert(1, aMonthAgo);

      // return collectionsDatesData;
      return dates;
    } finally {
      client.close();
    }

  }


  // Function to convert different model type to CollectionsReportModel
  CollectionsReportModel convertToCollectionsReportModel(Unit vacant) {
    // Example conversion logic
    int id = vacant.id!;
    String name = vacant.name!;
    int amount = vacant.amount!;
    int isAvailable = vacant.isAvailable!;
    String squareMeters = vacant.squareMeters!;
    String description = vacant.description.toString();
    int unitType = vacant.unitType!;
    int floorId = vacant.floorId!;
    int scheduleId = vacant.scheduleId!;
    int propertyId = vacant.propertyId!;
    int currencyId = vacant.currencyId!;
    dynamic createdBy = vacant.createdBy!;
    dynamic updatedBy = vacant.updatedBy;
    DateTime createdAt = vacant.createdAt!;
    DateTime updatedAt = vacant.updatedAt!;
    int convertedAmount = vacant.convertedAmount!;
    int? usdAmount = vacant.foreignAmount ?? 0;
    int? ugxAmount = vacant.baseAmount ?? 0;

    // Create CollectionsReportModel object
    return CollectionsReportModel(
      paid: 0,
        balance: 0,
        discountAmount: 0,
        tenantunit: Tenantunit(
          id: 0,
            unit: Unit(
          name: name,
          id: id,
          amount: amount,
          description: description,
          updatedAt: updatedAt,
          createdAt: createdAt,
          createdBy: createdBy,
          convertedAmount: convertedAmount,
          currencyId: currencyId,
          floorId: floorId,
          isAvailable: isAvailable,
          propertyId: propertyId,
          scheduleId: scheduleId,
          squareMeters: squareMeters,
          baseAmount: ugxAmount,
          unitType: unitType,
          updatedBy: updatedBy,
          foreignAmount: usdAmount,
        ),
          tenant: null
        ),
    );
  }


}

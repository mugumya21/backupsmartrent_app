import 'dart:convert';
import 'dart:io';

import 'package:smart_rent/configs/app_configs.dart';

import 'package:smart_rent/data_layer/models/reports/collections/collections_report_model.dart';
import 'package:smart_rent/data_layer/models/reports/lease_status/lease_status_report_model.dart';
// import 'package:smart_rent/data_layer/models/reports/unpaid/unpaid_reports_model.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/collections_report_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/lease_report_repo.dart';


class LeaseReportRepoImpl implements LeaseReportRepo {

  @override
  Future<List<LeaseReportModel>> getLeaseReport(
      String token, int? propertyId, int? unitId, int? tenantId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/reports/leasestatus?form-submit=&property_id=$propertyId&unit_id=$unitId&tenant_id=$tenantId');

      var response = await client.get(url, headers: headers);
      List unpaidData = jsonDecode(response.body)['schedules'] ?? [];
      if (kDebugMode) {
        print("unpaid Report RESPONSE: $response");
        print("unpaid Report RESPONSE: ${response.body}");
      }


      List<LeaseReportModel> unpaidList = unpaidData
          .map((schedule) => LeaseReportModel.fromJson(schedule))
          .toList();

      // unpaidList.sort((a, b) => b.balance!.compareTo(a.balance!));

      return unpaidList;

      // return unpaidData
      //     .map((nation) => UnpaidReportScheduleModel.fromJson(nation))
      //     .toList();
      return [];
    } finally {
      client.close();
    }
  }

}

import 'dart:convert';
import 'dart:io';

import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/currency/currency_model.dart';
import 'package:smart_rent/data_layer/models/employee/employee_model.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/currency_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/employee_repo.dart';


class EmployeeRepoImpl implements EmployeeRepo {
  @override
  Future<List<EmployeeModel>> getAllEmployees(
    String token,
  ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/hr/employees');

      var response = await client.get(url, headers: headers);
      List employeeData = jsonDecode(response.body);
      if (kDebugMode) {
        print("employees RESPONSE: $response");
      }
      return employeeData
          .map((nation) => EmployeeModel.fromJson(nation))
          .toList();
    } finally {
      client.close();
    }
  }
}

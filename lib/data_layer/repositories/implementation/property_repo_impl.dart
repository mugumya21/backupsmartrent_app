import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/property/property_documents_list_model.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/property_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;


class PropertyRepoImpl implements PropertyRepo {
  @override
  @override
  Future<List<Property>> getALlProperties(String token) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/properties');

      var response = await client.get(url, headers: headers);
      List propertyData = jsonDecode(response.body)['properties'] ?? [];
      if (kDebugMode) {
        print("property RESPONSE: $response");
        print("property Data: $propertyData");
      }
      return propertyData
          .map((property) => Property.fromJson(property))
          .toList();
    } finally {
      client.close();
    }
  }

  @override
  Future<Property> getSingleProperty(int id, String token) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/properties/$id');

      var response = await client.get(url, headers: headers);

      if (kDebugMode) {
        print("Property DETAILS RESPONSE: $response");
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Property.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load property details');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load property details');
    } finally {
      client.close();
    }
  }

  @override
  Future<dynamic> addProperty(
      String token,
      String name,
      String location,
      String sqm,
      String description,
      int propertyTypeId,
      int propertyCategoryId) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/properties');

      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode({
          'name': name,
          'location': location,
          'square_meters': sqm,
          'description': description,
          'property_type_id': propertyTypeId,
          'property_category_id': propertyCategoryId,
        }),
      );

      if (kDebugMode) {
        print("Add Property RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('add property response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }


  @override
  Future<dynamic> updateProperty(
      String token,
      String name,
      String location,
      String sqm,
      String description,
      int propertyTypeId,
      int propertyCategoryId,
      int propertyId,
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/rent/properties/$propertyId');

      var response = await client.put(
        url,
        headers: headers,
        body: jsonEncode({
          'name': name,
          'location': location,
          'square_meters': sqm,
          'description': description,
          'property_type_id': propertyTypeId,
          'property_category_id': propertyCategoryId,
        }),
      );

      if (kDebugMode) {
        print("Update Property RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Update property response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }


  @override
  Future<List<PropertyDocumentsListModel>> getAllPropertyDocuments(
      String token, int propertyId, int fileTypeId
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url =
      Uri.parse('$appUrl/api/main/documents/$propertyId/filetype/$fileTypeId');


      var response = await client.get(url, headers: headers);
      List documentData = jsonDecode(response.body);
      if (kDebugMode) {
        print("property documents RESPONSE: $response");
        print("property documents Data: ${response.body}");
        print("property documents List: $documentData");
      }
      return documentData
          .map((payment) => PropertyDocumentsListModel.fromJson(payment))
          .toList();
    } finally {
      client.close();
    }
  }


  @override
  Future<dynamic> uploadPropertyFile(String token, File imageFile, int docId, int fileTypeId) async {
    String? uniquePhotoId = const Uuid().v4();
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));


    print('my Path = ${imageFile.path}');
    print('my Path extension = ${imageFile.path.split('/').toString()}');
    print('my file = ${imageFile}');

    try {

      Uri url = Uri.https(appUrl.replaceRange(0, 8, ''),
          'api/main/upload');

      final extension = p.extension(imageFile.path);
      String filename = p.basename(imageFile.path);
      FormData formData = FormData.fromMap({
        "docid": docId,
        "filetype": fileTypeId,
        "file": await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last.toString())
      });

      dio.options.headers["authorization"] = "Bearer ${currentUserToken}";
      var response = await dio.post(url.toString(), data: formData);
      // print(response.body);
      // var data = json.decode(response.body);
      // print(response);
      // print(data);


      if (kDebugMode) {
        print("Upload Payments RESPONSE: $response");
        print("Upload Payments RESPONSE body: ${response.data}");
      }
      var responseBody = jsonDecode(utf8.decode(response.data));
      print('Upload Payments response body $responseBody');
      return jsonDecode(utf8.decode(response.data)) as Map;
    } catch (e) {
      print(e);
    } finally {

    }


  }

  @override
  Future<dynamic> updatePropertyMainImage(
      String token,
      int docId,
      int externalId,
      int docTypeId,
      ) async {
    var client = RetryClient(http.Client());
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

      var url = Uri.parse('$appUrl/api/main/setfeaturedimage');

      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode({
          'id': docId,
          'key': externalId,
          'type': docTypeId,
        }),
      );

      if (kDebugMode) {
        print("Update Property RESPONSE: $response");
      }
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Update property response body $responseBody');
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }




}

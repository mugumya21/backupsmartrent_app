import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/auth/login_model.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:smart_rent/data_layer/models/auth/login_response.dart';
import 'package:smart_rent/data_layer/models/user_model.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/utilities/app_init.dart';


class AuthService {


  // static Future<Map<String, dynamic>> signInUser(LoginModel loginModel) async {
  //   Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
  //   dio.options.headers['content-Type'] = "application/json";
  //   dio.options.headers['Accept'] = "application/json";
  //   dio.options.followRedirects = false;
  //
  //   try {
  //     var response = await dio.post(
  //         Uri.https(appUrl.replaceRange(0, 8, ''), 'api/login').toString(),
  //         data: jsonEncode(loginModel.toJson()));
  //
  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       throw Error();
  //     }
  //   } finally {
  //     dio.close();
  //   }
  // }


  static Future<CurrentSmartUserLoginResponse?> signInUser(
      String url,
      String email,
      String password, {
        Function()? onSuccess,
        Function()? onWrongPassword,
        Function()? onError,
      }) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
    dio.options.headers['content-Type'] = "application/json";
    dio.options.headers['Accept'] = "application/json";
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https(url.replaceRange(0, 8, ''), 'api/login').toString(),
          data: jsonEncode({'email': email, 'password': password}));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          response.data['app_url'] = url;
          var userResponse = CurrentSmartUserLoginResponse.fromJson(response.data);
          currentSmartUserLoginResponse = userResponse;
          currentUserToken = userResponse.token;
          currentUserBaseCurrencyCode = userResponse.baseCurrencyCode;
          currentUserLetterHead = userResponse.letterHead;
          currentSmartUserModel = userResponse.user;

          print('My API User = $currentSmartUserLoginResponse');
          print('My API User elements = ${currentSmartUserLoginResponse.token}');
          print('My API User base Code and letter Head= ${currentUserBaseCurrencyCode} and ${currentUserLetterHead}');

          if (onSuccess != null) {
            onSuccess();
          }
          return userResponse;
        } else {
          if (response.data['message'] == 'WRONG_PASSWORD_PROVIDED') {
            if (onWrongPassword != null) {
              onWrongPassword();
            }
          }
        }
      } else {
        if (onError != null) {
          onError();
        }
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    } finally {
      dio.close();
    }
    return null;
  }


  static Future<String?> checkIfUserExists(
      String email, {
        Function()? onSuccess,
        Function()? onNoUser,
        Function()? onError,
      }) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    dio.options.headers['content-Type'] = "application/json";
    dio.options.headers['Accept'] = "application/json";
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https('app.smartrentmanager.com', 'api/login').toString(),
          data: json.encode({
            'email': email,
          }));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          appUrl = response.data['user']['app_url'];
          return response.data['user']['app_url'];
        } else {
          if (response.data['message'] == 'USER_NOT_FOUND') {
            if (onNoUser != null) {
              onNoUser();
            }
          }
        }
      } else {
        if (onError != null) {
          onError();
        }
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    } finally {
      dio.close();
    }
    return null;
  }

  static requestReset(String email,
      {Function()? onSuccess,
        Function()? onNoUser,
        Function()? onWrongPassword,
        Function()? onError,
        Function(dynamic e)? onErrors}) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    dio.options.headers['content-Type'] = "application/json";
    dio.options.headers['Accept'] = "application/json";
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https('app.smartrentmanager.com', 'api/login').toString(),
          data: json.encode({
            'email': email,
          }));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          var url = response.data['user']['app_url'];

          var resetRequest = await dio.post(
              Uri.https(url.replaceRange(0, 8, ''), 'api/password/reset')
                  .toString(),
              data: json.encode({'email': email}));

          if (resetRequest.statusCode == 200) {
            if (onSuccess != null) {
              onSuccess();
            }
          } else {
            if (onError != null) {
              onError();
            }
          }
        } else {
          if (response.data['message'] == 'USER_NOT_FOUND') {
            if (onNoUser != null) {
              onNoUser();
            }
          }
        }
      } else {
        if (onError != null) {
          onError();
        }
      }
    } finally {
      dio.close();
    }
  }

  static Future uploadFCMToken(String email) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
    dio.options.headers['content-Type'] = "application/json";
    dio.options.headers['Accept'] = "application/json";
    // dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
    dio.options.followRedirects = false;

    try {
      await dio.post('https://app.smartrentmanager.com/api/save/fcm/token',
          data: jsonEncode({'fcm_token': currentUserFcmToken, 'email': email}));
    } finally {
      dio.close();
    }
  }


  static Future signOutUser(BuildContext context) async {
    final preferences = GetSecureStorage(
        password: 'infosec_technologies_ug_rent_manager');


      currentUserToken = '';
      currentSmartUserModel = null;
      await savedBox.remove('email');
      await savedBox.remove('name');
      await savedBox.erase();
    await preferences.remove('email');
    await preferences.remove('name');
    await preferences.remove('image');
    Fluttertoast.showToast(msg: 'Logged Out SuccessFully',
        gravity: ToastGravity.CENTER,
        backgroundColor: AppTheme.green
    );

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

  }



  static resetForgottenPassword(String url ,String email, String password, String token,
      {Function()? onSuccess,
        Function()? onNoUser,
        Function()? onWrongPassword,
        Function()? onError,
        Function(dynamic e)? onErrors}) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    dio.options.headers['content-Type'] = "application/json";
    dio.options.headers['Accept'] = "application/json";
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https('app.smartrentmanager.com', 'api/login').toString(),
          data: json.encode({
            'email': email,
          }));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          var url = response.data['user']['app_url'];

          var resetRequest = await dio.post(
              Uri.https(url.replaceRange(0, 8, ''), 'api/password/submit')
                  .toString(),
              data: json.encode({
                'email': email,
                'password': password,
                'token': token,
              }));

          if (resetRequest.statusCode == 200) {
            if (onSuccess != null) {
              onSuccess();
            }
          } else {
            if (onError != null) {
              onError();
            }
          }
        } else {
          if (response.data['msg'] == 'Invalid token provided') {
            if (onNoUser != null) {
              onNoUser();
            }
          }
        }
      } else {
        if (onError != null) {
          onError();
        }
      }
    } finally {
      dio.close();
    }
  }


}

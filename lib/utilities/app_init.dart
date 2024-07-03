
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:smart_rent/data_layer/models/auth/login_response.dart';
import 'package:smart_rent/data_layer/models/user_model.dart';


final savedBox = GetSecureStorage(
    password: 'infosec_technologies_ug_rent_manager');
String? savedEmail = savedBox.read('email');
String? saveName = savedBox.read('name');
// currentUsername = box.read('name');


late CurrentSmartUser currentUser;
late CurrentSmartUserLoginResponse currentSmartUserLoginResponse;


String? currentUsername;
String? currentUserAvatar;
String? currentUserToken;
String? currentUserFcmToken;
String? success;
String? currentUserLetterHead;
String? currentUserBaseCurrencyCode;
CurrentSmartUserModel? currentSmartUserModel;

bool propertiesScrollVisibility = true;

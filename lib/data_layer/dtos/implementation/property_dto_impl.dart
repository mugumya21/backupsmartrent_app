

import 'package:smart_rent/data_layer/models/property/add_response_model.dart';
import 'package:smart_rent/data_layer/models/property/update_property_response_model.dart';
import 'package:smart_rent/data_layer/models/property/upload_property_file_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/property_repo_impl.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/property_repo.dart';

class PropertyDtoImpl {
  static Future<AddPropertyResponseModel> addProperty(
    String token,
    String name,
    String location,
    String sqm,
    String description,
    int propertyTypeId,
    int propertyCategoryId, {
    Function()? onSuccess,
    Function()? onError,
  }) async {
    PropertyRepo propertyRepo = PropertyRepoImpl();
    var result = await propertyRepo
        .addProperty(token, name, location, sqm, description, propertyTypeId,
            propertyCategoryId)
        .then((response) =>
            AddPropertyResponseModel.fromJson(response));

    return result;
  }


  static Future<UpdatePropertyResponseModel> updateProperty(
      String token,
      String name,
      String location,
      String sqm,
      String description,
      int propertyTypeId,
      int propertyCategoryId,
      int propertyId, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    PropertyRepo propertyRepo = PropertyRepoImpl();
    var result = await propertyRepo
        .updateProperty(token, name, location, sqm, description, propertyTypeId,
        propertyCategoryId, propertyId)
        .then((loginResponse) =>
        UpdatePropertyResponseModel.fromJson(loginResponse));

    return result;
  }

  static Future<UploadPropertyFileResponseModel> uploadPropertyFile(
      String token, dynamic imageFile, int docId, int fileTypeId, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    PropertyRepo propertyRepo = PropertyRepoImpl();
    var result = await propertyRepo.uploadPropertyFile( token, imageFile, docId, fileTypeId)
        .then((response) => UploadPropertyFileResponseModel.fromJson(response));

    return result;
  }


  static Future<UpdatePropertyResponseModel> updatePropertyMainImage(
      String token,
      int docId,
      int externalId,
      int docTypeId, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    PropertyRepo propertyRepo = PropertyRepoImpl();
    var result = await propertyRepo
        .updatePropertyMainImage(token, docId, externalId, docTypeId)
        .then((response) =>
        UpdatePropertyResponseModel.fromJson(response));

    return result;
  }

}

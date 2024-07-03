import 'dart:io';

abstract class PropertyRepo {
  Future<dynamic> getALlProperties(String token);

  Future<dynamic> getSingleProperty(int id, String token);

  Future<dynamic> addProperty(
      String token,
      String name,
      String location,
      String sqm,
      String description,
      int propertyTypeId,
      int propertyCategoryId);

  Future<dynamic> updateProperty(
      String token,
      String name,
      String location,
      String sqm,
      String description,
      int propertyTypeId,
      int propertyCategoryId,
      int propertyId
      );

  Future<dynamic> getAllPropertyDocuments(String token, int propertyId, int fileTypeId);
  Future<dynamic> uploadPropertyFile(String token, File imageFile, int docId, int fileTypeId);
  Future<dynamic> updatePropertyMainImage(String token, int docId, int externalId, int docTypeId,);


}


import 'package:smart_rent/data_layer/models/unit/add_unit_response.dart';
import 'package:smart_rent/data_layer/models/unit/delete_unit_response_model.dart';
import 'package:smart_rent/data_layer/models/unit/update_unit_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/unit_repo_impl.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/unit_repo.dart';

class UnitDtoImpl {
  static Future<AddUnitResponse> addUnitToProperty(
      String token, int unitTypeId, int floorId, String name, String sqm,
      int periodId, int currencyId, int initialAmount, String description, int propertyId, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    UnitRepo unitRepo = UnitRepoImpl();
    var result = await unitRepo
        .addUnitToProperty(token, unitTypeId, floorId, name, sqm, periodId, currencyId, initialAmount,
      description, propertyId
    ).then((response) => AddUnitResponse.fromJson(response));

    return result;
  }


  static Future<DeleteUnitResponseModel> deleteUnit(
      String token,
      int unitId,{
        Function()? onSuccess,
        Function()? onError,
      }) async {
    print("In here");
    var result;
    UnitRepo tenantUnitRepo = UnitRepoImpl();
    await tenantUnitRepo
        .deleteUnit(
      token,
      unitId,
    )
        .then((response) => result = DeleteUnitResponseModel.fromJson(response));
    print("Then here");

    return result;
  }


  static Future<UpdateUnitResponseModel> updateUnit(
      String token, int unitTypeId, int floorId, String name, String sqm,
      int periodId, int currencyId, int initialAmount, String description, int propertyId, int unitId, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    UnitRepo unitRepo = UnitRepoImpl();
    var result = await unitRepo
        .updateUnit(token, unitTypeId, floorId, name, sqm, periodId, currencyId, initialAmount,
        description, propertyId,  unitId
    ).then((response) => UpdateUnitResponseModel.fromJson(response));

    return result;
  }

}

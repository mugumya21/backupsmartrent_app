import 'package:smart_rent/data_layer/models/tenant_unit/add_tenant_unit_response.dart';
import 'package:smart_rent/data_layer/models/tenant_unit/delete_tenant_unit_response_model.dart';
import 'package:smart_rent/data_layer/models/tenant_unit/update_tenant_unit_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/tenant_unit_repo_impl.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/tenant_unit_repo.dart';

class TenantUnitDtoImpl {
  static Future<AddTenantUnitResponse> addTenantUnit(
    String token,
    int tenantId,
    int unitId,
    int periodId,
    String duration,
    String fromDate,
    String toDate,
    String unitAmount,
    int currencyId,
    String agreedAmount,
    String description,
    int propertyId, {
    Function()? onSuccess,
    Function()? onError,
  }) async {
    print("In here");
    var result;
    TenantUnitRepo tenantUnitRepo = TenantUnitRepoImpl();
    await tenantUnitRepo
        .addTenantUnit(
            token,
            tenantId,
            unitId,
            periodId,
            duration,
            fromDate,
            toDate,
            unitAmount,
            currencyId,
            agreedAmount,
            description,
            propertyId)
        .then((response) => result = AddTenantUnitResponse.fromJson(response));
    print("Then here");

    return result;
  }


  static Future<UpdateTenantUnitResponseModel> updateTenantUnit(
      String token,
      int tenantId,
      int unitId,
      int periodId,
      String duration,
      String fromDate,
      String toDate,
      String unitAmount,
      int currencyId,
      String agreedAmount,
      String description,
      int propertyId,
      int tenantUnitId,{
        Function()? onSuccess,
        Function()? onError,
      }) async {
    print("In here");
    var result;
    TenantUnitRepo tenantUnitRepo = TenantUnitRepoImpl();
    await tenantUnitRepo
        .updateTenantUnit(
        token,
        tenantId,
        unitId,
        periodId,
        duration,
        fromDate,
        toDate,
        unitAmount,
        currencyId,
        agreedAmount,
        description,
        propertyId,
       tenantUnitId,
    )
        .then((response) => result = UpdateTenantUnitResponseModel.fromJson(response));
    print("Then here");

    return result;
  }


  static Future<DeleteTenantUnitResponseModel> deleteTenantUnit(
      String token,
      int tenantUnitId,{
        Function()? onSuccess,
        Function()? onError,
      }) async {
    print("In here");
    var result;
    TenantUnitRepo tenantUnitRepo = TenantUnitRepoImpl();
    await tenantUnitRepo
        .deleteTenantUnit(
      token,
      tenantUnitId,
    )
        .then((response) => result = DeleteTenantUnitResponseModel.fromJson(response));
    print("Then here");

    return result;
  }

}

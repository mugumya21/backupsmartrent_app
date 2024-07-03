

import 'package:smart_rent/data_layer/models/auth/change_password_response_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/account_repo_impl.dart';
import 'package:smart_rent/data_layer/repositories/interfaces/account_repo.dart';

class AccountDtoImpl {
  static Future<ChangePasswordResponseModel> changePassword(
      String token,
      int userId,
      String oldPassword,
      String password,
      String passwordConfirmation, {
        Function()? onSuccess,
        Function()? onError,
      }) async {
    AccountRepo accountRepo = AccountRepoImpl();
    var result = await accountRepo
        .changePassword(token, userId, oldPassword, password, passwordConfirmation)
        .then((response) => ChangePasswordResponseModel.fromJson(response));

    return result;
  }
}

import 'dart:io';

abstract class AccountRepo {

  Future<dynamic> changePassword(
      String token,
      int userId,
      String oldPassword,
      String password,
      String passwordConfirmation
      );


}

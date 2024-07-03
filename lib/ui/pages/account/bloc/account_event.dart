part of 'account_bloc.dart';


@immutable
abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class ChangePasswordEvent extends AccountEvent {
  final String token;
  final int userId;
  final String oldPassword;
  final String password;
  final String passwordConfirmation;
  final bool isChangePasswordLoading;


  const ChangePasswordEvent(
      this.token,
      this.userId,
      this.oldPassword,
      this.password,
      this.passwordConfirmation,
      this.isChangePasswordLoading,
);

  @override
  List<Object?> get props => [
    token,
    userId,
    oldPassword,
    password,
    passwordConfirmation,
    isChangePasswordLoading
  ];
}


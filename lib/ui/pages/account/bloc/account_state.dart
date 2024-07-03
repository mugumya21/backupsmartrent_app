part of 'account_bloc.dart';

enum AccountStatus {
  initial,
  success,
  loading,
  accessDenied,
  error,
  empty,
  notFound,
}

 class AccountState extends Equatable {
  final ChangePasswordResponseModel? changePasswordResponseModel;
  final AccountStatus status;
  final String? message;
  final bool? isChangePasswordLoading;

  const AccountState({
    this.changePasswordResponseModel,
    this.status = AccountStatus.initial,
    this.message,
    this.isChangePasswordLoading = false,
  });

  AccountState copyWith({
     ChangePasswordResponseModel? changePasswordResponseModel,
     AccountStatus? status,
     String? message,
     bool? isChangePasswordLoading,
 }) {
    return AccountState(
      changePasswordResponseModel: changePasswordResponseModel ?? this.changePasswordResponseModel,
      status: status ?? this.status,
      message: message ?? this.message,
      isChangePasswordLoading: isChangePasswordLoading ?? this.isChangePasswordLoading,
    );
}

  @override
  // TODO: implement props
  List<Object?> get props => [changePasswordResponseModel, status, message];
}

final class AccountInitial extends AccountState {
  @override
  List<Object> get props => [];
}

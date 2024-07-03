import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_rent/data_layer/dtos/implementation/account_dto_impl.dart';
import 'package:smart_rent/data_layer/models/auth/change_password_response_model.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<ChangePasswordEvent>(_mapChangePasswordEventToState);

  }

  _mapChangePasswordEventToState(
      ChangePasswordEvent event, Emitter<AccountState> emit) async {
    emit(state.copyWith(
        status: AccountStatus.loading, isChangePasswordLoading: true));
    await AccountDtoImpl.changePassword(
        currentUserToken.toString(),
        event.userId,
        event.oldPassword,
        event.password,
        event.passwordConfirmation,
    )
        .then((response) {
      log('success ${response.msg}');

      if (response != null) {
        emit(state.copyWith(
            status: AccountStatus.success,
            isChangePasswordLoading: false,
            changePasswordResponseModel: response,
            message: response.msg));
      } else {
        emit(state.copyWith(
          status: AccountStatus.accessDenied,
          isChangePasswordLoading: false,
        ));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          status: AccountStatus.error,
          isChangePasswordLoading: false,
          message: error.toString()));
    });
  }

}

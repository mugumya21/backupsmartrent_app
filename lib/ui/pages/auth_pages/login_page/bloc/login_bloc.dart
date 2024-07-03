import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginInitial>(_mapInitialEventToState);
    on<ResetPassword>(_mapResetPasswordEventToState);
    on<LoginUser>(_mapLoginUserEventToState);
    on<SignInUser>(_mapSignInUserEventToState);
    on<ChangeUser>(_mapChangeUserEventToState);
    on<FocusEmail>(_mapFocusEmailEventToState);
    on<FocusPassword>(_mapFocusPasswordEventToState);
    on<ForgotPassword>(_mapForgotPasswordEventToState);
    on<RefreshScreen>(_mapRefreshScreenEventToState);
  }

  _mapInitialEventToState(LoginInitial event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      // final box = GetSecureStorage(
      //     password: 'infosec_technologies_ug_rent_manager');
      //
      // String? email = box.read('email');
      // String? name = box.read('name');
      // String? image = box.read('image');
      //
      // log("Email: $email");
      // log("Name: $name");
      // log("image: $image");

      // if (email != null && email.isNotEmpty) {
      emit(state.copyWith(
        status: LoginStatus.loginUser,
        // email: email,
        // name: name,
        // image: image,
      ));
      // } else if (email != null && email.isEmpty) {
      //   emit(state.copyWith(
      //     status: LoginStatus.loginUser,
      //   ));
      // } else if (email == null) {
      //   emit(state.copyWith(
      //     status: LoginStatus.loginUser,
      //   ));
      // }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  _mapResetPasswordEventToState(ResetPassword event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  _mapRefreshScreenEventToState(RefreshScreen event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.loading));
    emit(state.copyWith(status: LoginStatus.success));
  }

  _mapFocusEmailEventToState(FocusEmail event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      status: LoginStatus.focusEmail,
      isEmailFocused: true,
      isPasswordFocus: false,
    ));
  }

  _mapFocusPasswordEventToState(FocusPassword event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      status: LoginStatus.focusPassword,
      isEmailFocused: false,
      isPasswordFocus: true,
    ));
  }

  _mapLoginUserEventToState(LoginUser event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.loginUser));
  }

  _mapSignInUserEventToState(SignInUser event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.signInUser));
  }

  _mapChangeUserEventToState(ChangeUser event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.changeUser));
  }

  _mapForgotPasswordEventToState(
      ForgotPassword event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.forgotPassword));
  }

  @override
  void onChange(Change<LoginState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print("Change: $change");
    }
  }

  @override
  void onEvent(LoginEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      print("Event: $event");
    }
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      print("Transition: $transition");
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    if (kDebugMode) {
      print("Error: $error");
      print("StackTrace: $stackTrace");
    }
  }
}

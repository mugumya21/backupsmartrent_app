import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/models/unit/unit_type_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/unit_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'unit_type_event.dart';
part 'unit_type_state.dart';

class UnitTypeBloc extends Bloc<UnitTypeEvent, UnitTypeState> {
  UnitTypeBloc() : super(UnitTypeInitial()) {
    on<LoadAllUnitTypesEvent>(_mapFetchAllUnitTypesToState);

  }


  _mapFetchAllUnitTypesToState(
      LoadAllUnitTypesEvent event, Emitter<UnitTypeState> emit) async {
    emit(state.copyWith(status: UnitTypeStatus.loading));
    await UnitRepoImpl()
        .getUnitTypes(currentUserToken.toString(), event.id)
        .then((unitTypes) {
      if (unitTypes.isNotEmpty) {
        emit(state.copyWith(status: UnitTypeStatus.success, unitTypes: unitTypes));
      } else {
        emit(state.copyWith(status: UnitTypeStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: UnitTypeStatus.error));
      if (kDebugMode) {
        log("Error: $error");
        log("Stacktrace: $stackTrace");
      }
    });
  }

  @override
  void onChange(Change<UnitTypeState> change) {
    super.onChange(change);
    if (kDebugMode) {
      log("Change: $change");
    }
  }

  @override
  void onEvent(UnitTypeEvent event) {
    super.onEvent(event);
    if (kDebugMode) {
      log("Event: $event");
    }
  }

  @override
  void onTransition(Transition<UnitTypeEvent, UnitTypeState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      log("Transition: $transition");
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    if (kDebugMode) {
      log("Error: $error");
      log("StackTrace: $stackTrace");
    }
  }

}

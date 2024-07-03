import 'dart:async';
import 'dart:developer';

import 'package:smart_rent/data_layer/dtos/implementation/unit_dto_impl.dart';
import 'package:smart_rent/data_layer/models/unit/add_unit_response.dart';
import 'package:smart_rent/data_layer/models/unit/delete_unit_response_model.dart';
import 'package:smart_rent/data_layer/models/unit/unit_model.dart';
import 'package:smart_rent/data_layer/models/unit/unit_type_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/unit_repo_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';



part 'unit_event.dart';
part 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  UnitBloc() : super(UnitState()) {
    on<LoadAllUnitsEvent>(_mapFetchUnitsToState);
    on<RefreshUnitsEvent>(_mapRefreshUnitsToState);
    on<DeleteUnitEvent>(_mapDeleteUnitEventToState);
  }

  _mapFetchUnitsToState(
      LoadAllUnitsEvent event, Emitter<UnitState> emit) async {
    emit(state.copyWith(status: UnitStatus.loading));
    await UnitRepoImpl()
        .getALlUnits(currentUserToken.toString(), event.id)
        .then((units) {
      if (units.isNotEmpty) {
        emit(state.copyWith(status: UnitStatus.success, units: units));
      } else {
        emit(state.copyWith(status: UnitStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: UnitStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }

  _mapRefreshUnitsToState(
      RefreshUnitsEvent event, Emitter<UnitState> emit) async {
    // emit(state.copyWith(status: UnitStatus.reLoading));
    await UnitRepoImpl()
        .getALlUnits(currentUserToken.toString(), event.id)
        .then((units) {
      if (units.isNotEmpty) {
        emit(state.copyWith(status: UnitStatus.reLoaded, units: units));
      } else {
        emit(state.copyWith(status: UnitStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: UnitStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }

  // _mapViewSingleFloorDetailsEventToState(LoadSinglePropertyEvent event, Emitter<PropertyState> emit) async {
  //   emit(state.copyWith(status: PropertyStatus.loadingDetails,));
  //   await PropertyRepoImpl().getSingleProperty(event.id, userStorage.read('accessToken').toString()).then((property) {
  //     if(property != null) {
  //       emit(state.copyWith(status: PropertyStatus.successDetails, property: property));
  //     } else {
  //       emit(state.copyWith(status: PropertyStatus.emptyDetails, property: null));
  //     }
  //   }).onError((error, stackTrace) {
  //     emit(state.copyWith(status: PropertyStatus.errorDetails, isPropertyLoading: false));
  //   });
  //
  // }

  _mapDeleteUnitEventToState(
      DeleteUnitEvent event, Emitter<UnitState> emit) async {
    emit(state.copyWith(status: UnitStatus.loadingDelete, isLoading: true));
    await UnitDtoImpl.deleteUnit(
        currentUserToken.toString(),
        event.id
    ).then((response) {
      print('success ${response.msg}');

      if (response.msg != null) {
        emit(state.copyWith(
            status: UnitStatus.successDelete,
            isLoading: false,
            deleteUnitResponseModel: response));
        print('Delete Tenant Unit success ==  ${response.msg}');
      } else if (response.msg != null) {
        emit(state.copyWith(
            status: UnitStatus.errorDelete,
            isLoading: false,
            deleteUnitResponseModel: response,
            message: response.msg.toString()));
        print('Delete Tenant Unit failed ==  ${response.msg}');
      } else {
        emit(state.copyWith(
          status: UnitStatus.accessDeniedDelete,
          isLoading: false,
        ));
      }
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      emit(state.copyWith(
          status: UnitStatus.errorDelete,
          isLoading: false,
          message: error.toString()));
    });
  }


  @override
  void onEvent(UnitEvent event) {
    log(event.toString());
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<UnitEvent, UnitState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }

  @override
  void onChange(Change<UnitState> change) {
    log(change.toString());
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log(error.toString());
    log(stackTrace.toString());
    super.onError(error, stackTrace);
  }
}

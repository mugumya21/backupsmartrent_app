import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rent/data_layer/models/employee/employee_model.dart';
import 'package:smart_rent/data_layer/repositories/implementation/employee_repol_impl.dart';
import 'package:smart_rent/utilities/app_init.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeState()) {
    on<LoadAllEmployees>(_mapFetchEmployeesToState);
  }

  _mapFetchEmployeesToState(
      LoadAllEmployees event, Emitter<EmployeeState> emit) async {
    emit(state.copyWith(status: EmployeeStatus.loading));
    await EmployeeRepoImpl()
        .getAllEmployees(currentUserToken.toString())
        .then((employees) {
      if (employees.isNotEmpty) {
        emit(state.copyWith(status: EmployeeStatus.success, employees: employees));
      } else {
        emit(state.copyWith(status: EmployeeStatus.empty));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: EmployeeStatus.error));
      if (kDebugMode) {
        print("Error: $error");
        print("Stacktrace: $stackTrace");
      }
    });
  }

}

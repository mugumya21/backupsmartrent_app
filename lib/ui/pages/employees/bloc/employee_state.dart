part of 'employee_bloc.dart';


enum EmployeeStatus {
  initial,
  success,
  loading,
  accessDenied,
  error,
  empty,
  loadingDetails,
  successDetails,
  errorDetails,
  emptyDetails,
  successTT,
  loadingTT,
  accessDeniedTT,
  errorTT,
  emptyTT
}
 class EmployeeState extends Equatable {
  final List<EmployeeModel>? employees;
  final EmployeeStatus status;
  const EmployeeState({
    this.employees,
    this.status = EmployeeStatus.initial
});

  EmployeeState copyWith({
    List<EmployeeModel>? employees,
    EmployeeStatus? status,

  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      status: status ?? this.status,

    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [employees, status];

}

class EmployeeInitial extends EmployeeState {
  @override
  List<Object> get props => [];
}

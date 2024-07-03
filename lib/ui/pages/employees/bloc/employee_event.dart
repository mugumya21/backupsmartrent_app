part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
}


class LoadAllEmployees extends EmployeeEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
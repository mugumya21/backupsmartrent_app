part of 'unit_type_bloc.dart';

enum UnitTypeStatus {
  initial,
  success,
  loading,
  accessDenied,
  error,
  empty,

}


@immutable
class UnitTypeState extends Equatable {
  final List<UnitTypeModel>? unitTypes;
  final UnitTypeStatus status;
  final String? message;

  const UnitTypeState({this.unitTypes, this.status =  UnitTypeStatus.initial, this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [unitTypes, status, message];

  UnitTypeState copyWith({
     List<UnitTypeModel>? unitTypes,
     UnitTypeStatus? status,
     String? message,
}){
    return UnitTypeState(
      unitTypes: unitTypes ?? this.unitTypes,
      status: status ?? this.status,
      message: message ?? this.message,
    );
}

}

final class UnitTypeInitial extends UnitTypeState {
  @override
  List<Object> get props => [];
}

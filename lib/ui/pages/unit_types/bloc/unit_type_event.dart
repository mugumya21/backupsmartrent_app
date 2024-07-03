part of 'unit_type_bloc.dart';

@immutable
abstract class UnitTypeEvent extends Equatable {
  const UnitTypeEvent();
}


class LoadAllUnitTypesEvent extends UnitTypeEvent {
  final int id;

  const LoadAllUnitTypesEvent(this.id);

  @override
  List<Object?> get props => [];
}

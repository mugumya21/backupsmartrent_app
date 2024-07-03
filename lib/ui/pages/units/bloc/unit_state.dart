part of 'unit_bloc.dart';

enum UnitStatus {
  initial,
  success,
  loading,
  reLoading,
  reLoaded,
  accessDenied,
  error,
  empty,
  loadingDetails,
  successDetails,
  errorDetails,
  emptyDetails,
  successUT,
  loadingUT,
  accessDeniedUT,
  errorUT,
  emptyUT,
  successAdd,
  loadingAdd,
  accessDeniedAdd,
  errorAdd,
  emptyAdd,
  successDelete,
  loadingDelete,
  accessDeniedDelete,
  errorDelete,
  emptyDelete,
}

extension UnitStatusX on UnitStatus {
  bool get isInitial => this == UnitStatus.initial;

  bool get isLoading => this == UnitStatus.loading;

  bool get isSuccess => this == UnitStatus.success;

  bool get isError => this == UnitStatus.error;

  bool get isEmpty => this == UnitStatus.empty;

  bool get isReloaded => this == UnitStatus.reLoaded;

  bool get isReloading => this == UnitStatus.reLoading;

  bool get isAccessDenied => this == UnitStatus.accessDenied;
}

@immutable
class UnitState extends Equatable {
  final List<UnitModel> units;
  final UnitStatus status;
  final UnitModel? unitModel;
  final bool? isLoading;
  final List<UnitTypeModel>? unitTypes;
  final AddUnitResponse? addUnitResponse;
  final String? message;
  final DeleteUnitResponseModel? deleteUnitResponseModel;

  const UnitState(
      {List<UnitModel>? units,
      this.status = UnitStatus.initial,
      this.unitModel,
      this.isLoading = false,
      this.unitTypes,
      this.addUnitResponse,
      this.message = '',
      this.deleteUnitResponseModel,
      })
      : units = units ?? const [];

  UnitState copyWith({
    List<UnitModel>? units,
    UnitStatus? status,
    UnitModel? unitModel,
    bool? isLoading,
    List<UnitTypeModel>? unitTypes,
    AddUnitResponse? addUnitResponse,
    String? message,
    DeleteUnitResponseModel? deleteUnitResponseModel,
  }) {
    return UnitState(
      units: units ?? this.units,
      status: status ?? this.status,
      unitModel: unitModel ?? this.unitModel,
      isLoading: isLoading ?? this.isLoading,
      unitTypes: unitTypes ?? this.unitTypes,
      addUnitResponse: addUnitResponse ?? this.addUnitResponse,
      message: message ?? this.message,
      deleteUnitResponseModel: deleteUnitResponseModel ?? this.deleteUnitResponseModel,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        units,
        status,
        unitModel,
        isLoading,
        unitTypes,
        addUnitResponse,
        message,
    deleteUnitResponseModel
      ];
}

class UnitInitial extends UnitState {
  @override
  List<Object> get props => [];
}

part of 'nav_bar_bloc.dart';

enum NavBarStatus {
  initial,
  changing,
  changed,
}

extension NavBarStatusX on NavBarStatus {
  bool get isInitial => this == NavBarStatus.initial;

  bool get isChanging => this == NavBarStatus.changing;

  bool get isChanged => this == NavBarStatus.changed;
}

@immutable
class NavBarState extends Equatable {
  final Color color;
  final List<Screen>? screens;
  final IconData? icon;
  final bool isVisible;
  final NavBarStatus status;
  final int idSelected;

  const NavBarState({
    this.screens,
    this.color = Colors.transparent,
    this.icon,
    this.isVisible = true,
    this.status = NavBarStatus.changed,
    this.idSelected = 0,
  });

  @override
  List<Object?> get props =>
      [screens, color, icon, isVisible, status, idSelected];

  NavBarState copyWith({
    List<Screen>? screens,
    Color? color,
    IconData? icon,
    bool? isVisible,
    NavBarStatus? status,
    int? idSelected,
  }) {
    return NavBarState(
      screens: screens ?? this.screens,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isVisible: isVisible ?? this.isVisible,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}

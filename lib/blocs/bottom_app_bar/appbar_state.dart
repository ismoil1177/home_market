part of 'appbar_bloc.dart';

abstract class LandingPageState extends Equatable {
  final int tabIndex;
  const LandingPageState({required this.tabIndex});
}

class LandingPageInitial extends LandingPageState {
  const LandingPageInitial({required super.tabIndex});
  @override
  List<Object> get props => [tabIndex];
}

class LandingPageChange extends LandingPageState {
  const LandingPageChange({required super.tabIndex});
  @override
  List<Object> get props => [tabIndex];
}

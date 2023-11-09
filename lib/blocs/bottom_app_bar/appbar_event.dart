part of 'appbar_bloc.dart';

abstract class LandingPageEvent extends Equatable {}

class TabChange extends LandingPageEvent {
  final int tabIndex;

  TabChange({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

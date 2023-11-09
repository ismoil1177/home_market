import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appbar_event.dart';
part 'appbar_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc() : super(const LandingPageInitial(tabIndex: 0)) {
    on<TabChange>((event, emit) {
      print(event.tabIndex);
      emit(LandingPageChange(tabIndex: event.tabIndex));
    });
  }
}

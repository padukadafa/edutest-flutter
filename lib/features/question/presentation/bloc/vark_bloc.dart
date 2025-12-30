import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'vark_event.dart';
part 'vark_state.dart';

class VarkBloc extends Bloc<VarkEvent, VarkState> {
  VarkBloc() : super(const VarkState()) {
    on<SelectAnswer>((event, emit) {
      final updated = Map<String, int>.from(state.score);
      updated[event.type] = (updated[event.type] ?? 0) + 1;
      emit(state.copyWith(score: updated, index: state.index + 1));
    });
  }
}

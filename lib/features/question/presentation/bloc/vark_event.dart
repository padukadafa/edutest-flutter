part of 'vark_bloc.dart';

abstract class VarkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectAnswer extends VarkEvent {
  final String type;
  SelectAnswer(this.type);
}

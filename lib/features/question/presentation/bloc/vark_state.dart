part of 'vark_bloc.dart';

class VarkState extends Equatable {
  final int index;
  final Map<String, int> score;

  const VarkState({this.index = 0, this.score = const {}});

  VarkState copyWith({int? index, Map<String, int>? score}) {
    return VarkState(index: index ?? this.index, score: score ?? this.score);
  }

  @override
  List<Object?> get props => [index, score];
}

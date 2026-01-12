import 'package:equatable/equatable.dart';
import '../../data/models/vark_question_model.dart';

abstract class VarkEvent extends Equatable {
  const VarkEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestions extends VarkEvent {}

class SelectAnswer extends VarkEvent {
  final VarkType type;

  const SelectAnswer(this.type);

  @override
  List<Object?> get props => [type];
}

class NextQuestion extends VarkEvent {}

class PreviousQuestion extends VarkEvent {}

class GoToQuestion extends VarkEvent {
  final int index;

  const GoToQuestion(this.index);

  @override
  List<Object?> get props => [index];
}

class ResetVark extends VarkEvent {}

class SubmitQuiz extends VarkEvent {}

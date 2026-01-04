import 'package:equatable/equatable.dart';
import '../../domain/models/vark_question_model.dart';

abstract class VarkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadQuestions extends VarkEvent {}

class SelectAnswer extends VarkEvent {
  final VarkType type;

  SelectAnswer(this.type);

  @override
  List<Object?> get props => [type];
}

class NextQuestion extends VarkEvent {}

class PreviousQuestion extends VarkEvent {}

class GoToQuestion extends VarkEvent {
  final int index;

  GoToQuestion(this.index);

  @override
  List<Object?> get props => [index];
}

class ResetVark extends VarkEvent {}

class SubmitQuiz extends VarkEvent {}

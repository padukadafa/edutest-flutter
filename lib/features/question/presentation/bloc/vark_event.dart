part of 'vark_bloc.dart';

abstract class VarkEvent extends Equatable {
  const VarkEvent();

  @override
  List<Object?> get props => [];
}

class VarkStarted extends VarkEvent {}

class VarkQuestionAnswered extends VarkEvent {
  final String questionId;
  final VarkType selectedOption;

  const VarkQuestionAnswered({
    required this.questionId,
    required this.selectedOption,
  });

  @override
  List<Object?> get props => [questionId, selectedOption];
}

class VarkAssessmentCompleted extends VarkEvent {
  final int visualScore;
  final int auditoryScore;
  final int readingScore;
  final int kinestheticScore;

  const VarkAssessmentCompleted({
    required this.visualScore,
    required this.auditoryScore,
    required this.readingScore,
    required this.kinestheticScore,
  });

  @override
  List<Object?> get props => [
    visualScore,
    auditoryScore,
    readingScore,
    kinestheticScore,
  ];
}

class VarkMLPredictionReceived extends VarkEvent {
  final MLPrediction prediction;
  final Map<String, int> traditionalScores;

  const VarkMLPredictionReceived({
    required this.prediction,
    required this.traditionalScores,
  });

  @override
  List<Object?> get props => [prediction, traditionalScores];
}

class VarkMLPredictionFailed extends VarkEvent {
  final String message;

  const VarkMLPredictionFailed(this.message);

  @override
  List<Object?> get props => [message];
}

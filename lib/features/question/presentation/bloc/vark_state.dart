part of 'vark_bloc.dart';

abstract class VarkState extends Equatable {
  const VarkState();

  @override
  List<Object?> get props => [];
}

class VarkInitial extends VarkState {}

class VarkLoading extends VarkState {}

class VarkQuestionsLoaded extends VarkState {
  final List<VarkQuestion> questions;
  final int currentIndex;
  final Map<String, String> answers;
  final MLPrediction? livePrediction; // Live ML prediction after each answer

  const VarkQuestionsLoaded({
    required this.questions,
    required this.currentIndex,
    required this.answers,
    this.livePrediction,
  });

  @override
  List<Object?> get props => [questions, currentIndex, answers, livePrediction];

  VarkQuestionsLoaded copyWith({
    List<VarkQuestion>? questions,
    int? currentIndex,
    Map<String, String>? answers,
    MLPrediction? livePrediction,
    bool clearLivePrediction = false,
  }) {
    return VarkQuestionsLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      livePrediction: clearLivePrediction
          ? null
          : (livePrediction ?? this.livePrediction),
    );
  }
}

class VarkMLProcessing extends VarkState {
  final Map<String, int> traditionalScores;

  const VarkMLProcessing({required this.traditionalScores});

  @override
  List<Object?> get props => [traditionalScores];
}

class VarkMLSuccess extends VarkState {
  final MLPrediction prediction;
  final Map<String, int> traditionalScores;
  final VarkQuizResult result;

  const VarkMLSuccess({
    required this.prediction,
    required this.traditionalScores,
    required this.result,
  });

  @override
  List<Object?> get props => [prediction, traditionalScores, result];
}

class VarkError extends VarkState {
  final String message;

  const VarkError(this.message);

  @override
  List<Object?> get props => [message];
}

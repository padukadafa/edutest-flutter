import 'package:equatable/equatable.dart';
import '../../data/models/vark_question_model.dart';
import '../../data/entities/vark_result.dart';
import '../../domain/entities/ml_prediction.dart';

enum VarkStatus { initial, loading, ready, inProgress, completed, error }

class VarkState extends Equatable {
  final VarkStatus status;
  final List<VarkQuestion> questions;
  final int currentQuestionIndex;
  final Map<int, VarkType> answers;
  final Map<String, int> score;
  final VarkResult? quizResult;
  final MLPrediction? prediction;
  final String? errorMessage;

  const VarkState({
    this.status = VarkStatus.initial,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.score = const {},
    this.quizResult,
    this.prediction,
    this.errorMessage,
  });

  int get totalQuestions => questions.length;

  VarkQuestion? get currentQuestion =>
      questions.isNotEmpty ? questions[currentQuestionIndex] : null;

  VarkType? get currentAnswer => answers[currentQuestionIndex];

  bool get canGoNext => currentQuestionIndex < questions.length - 1;

  bool get canGoPrevious => currentQuestionIndex > 0;

  bool get allAnswered => answers.length == questions.length;

  bool get isFinished => status == VarkStatus.completed;

  double get progress =>
      questions.isEmpty ? 0 : (currentQuestionIndex + 1) / questions.length;

  VarkState copyWith({
    VarkStatus? status,
    List<VarkQuestion>? questions,
    int? currentQuestionIndex,
    Map<int, VarkType>? answers,
    Map<String, int>? score,
    VarkResult? quizResult,
    MLPrediction? prediction,
    String? errorMessage,
  }) {
    return VarkState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      quizResult: quizResult ?? this.quizResult,
      prediction: prediction ?? this.prediction,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questions,
    currentQuestionIndex,
    answers,
    score,
    quizResult,
    prediction,
    errorMessage,
  ];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_ml_prediction.dart';
import '../../domain/usecases/get_vark_questions.dart';
import '../../domain/usecases/calculate_vark_scores.dart';
import '../../data/models/vark_question_model.dart';
import 'vark_event.dart';
import 'vark_state.dart';

class VarkBloc extends Bloc<VarkEvent, VarkState> {
  final GetMLPrediction getMLPrediction;
  final GetVarkQuestions getVarkQuestions;
  final CalculateVarkScores calculateVarkScores;

  VarkBloc({
    required this.getMLPrediction,
    required this.getVarkQuestions,
    required this.calculateVarkScores,
  }) : super(const VarkState()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SelectAnswer>(_onSelectAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<GoToQuestion>(_onGoToQuestion);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<ResetVark>(_onResetVark);
  }

  Future<void> _onLoadQuestions(
    LoadQuestions event,
    Emitter<VarkState> emit,
  ) async {
    emit(state.copyWith(status: VarkStatus.loading));

    final result = await getVarkQuestions();

    result.fold(
      (failure) => emit(
        state.copyWith(status: VarkStatus.error, errorMessage: failure.message),
      ),
      (questions) => emit(
        state.copyWith(
          status: VarkStatus.inProgress,
          questions: questions,
          currentQuestionIndex: 0,
          answers: {},
          score: {},
        ),
      ),
    );
  }

  Future<void> _onSelectAnswer(
    SelectAnswer event,
    Emitter<VarkState> emit,
  ) async {
    final updatedAnswers = Map<int, VarkType>.from(state.answers)
      ..[state.currentQuestionIndex] = event.type;

    emit(state.copyWith(answers: updatedAnswers));
  }

  Future<void> _onNextQuestion(
    NextQuestion event,
    Emitter<VarkState> emit,
  ) async {
    if (state.canGoNext) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
    }
  }

  Future<void> _onPreviousQuestion(
    PreviousQuestion event,
    Emitter<VarkState> emit,
  ) async {
    if (state.canGoPrevious) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1),
      );
    }
  }

  Future<void> _onGoToQuestion(
    GoToQuestion event,
    Emitter<VarkState> emit,
  ) async {
    if (event.index >= 0 && event.index < state.totalQuestions) {
      emit(state.copyWith(currentQuestionIndex: event.index));
    }
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<VarkState> emit) async {
    emit(state.copyWith(status: VarkStatus.loading));

    // Convert answers (Map<int, VarkType>) to required format (Map<String, String>)
    final answersMap = <String, String>{};
    for (final entry in state.answers.entries) {
      answersMap[entry.key.toString()] = entry.value.letter;
    }

    final scoresResult = await calculateVarkScores(answersMap);

    scoresResult.fold(
      (failure) => emit(
        state.copyWith(status: VarkStatus.error, errorMessage: failure.message),
      ),
      (result) async {
        // Calculate traditional scores
        final traditionalScores = <String, int>{};
        for (final entry in result.scores.entries) {
          traditionalScores[entry.key.letter] = entry.value;
        }

        // Call ML prediction
        emit(
          state.copyWith(
            status: VarkStatus.loading,
            quizResult: result,
            score: traditionalScores,
          ),
        );

        final predictionResult = await getMLPrediction(
          visualScore: traditionalScores['V'] ?? 0,
          auditoryScore: traditionalScores['A'] ?? 0,
          readingScore: traditionalScores['R'] ?? 0,
          kinestheticScore: traditionalScores['K'] ?? 0,
        );

        predictionResult.fold(
          (failure) => emit(
            state.copyWith(
              status: VarkStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (prediction) => emit(
            state.copyWith(
              status: VarkStatus.completed,
              prediction: prediction,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onResetVark(ResetVark event, Emitter<VarkState> emit) async {
    emit(const VarkState());
  }
}

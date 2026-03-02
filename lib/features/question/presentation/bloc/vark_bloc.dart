import 'dart:async';
import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../cubit/vark_cubit.dart';
import '../../domain/entities/ml_prediction.dart';
import '../../domain/usecases/get_vark_questions.dart';
import '../../domain/usecases/calculate_vark_scores.dart';

part 'vark_event.dart';
part 'vark_state.dart';

class VarkBloc extends Bloc<VarkEvent, VarkState> {
  final GetVarkQuestions getVarkQuestions;
  final CalculateVarkScores calculateVarkScores;
  final VarkCubit varkCubit; // ← Cubit untuk server connection

  StreamSubscription? _cubitSubscription;

  VarkBloc({
    required this.getVarkQuestions,
    required this.calculateVarkScores,
    required this.varkCubit,
  }) : super(VarkInitial()) {
    // Listen to Cubit state changes
    _cubitSubscription = varkCubit.stream.listen((cubitState) {
      if (cubitState is VarkCubitPredictionSuccess) {
        // Check if we're in processing state (final prediction)
        if (state is VarkMLProcessing) {
          final processingState = state as VarkMLProcessing;
          add(
            VarkMLPredictionReceived(
              prediction: cubitState.prediction,
              traditionalScores: processingState.traditionalScores,
            ),
          );
        }
        // Check if we're in questions loaded state (live prediction)
        else if (state is VarkQuestionsLoaded) {
          add(VarkLivePredictionReceived(prediction: cubitState.prediction));
        }
      } else if (cubitState is VarkCubitConnectionError) {
        // Emit error state
        add(VarkMLPredictionFailed(cubitState.message));
      }
    });

    on<VarkStarted>(_onStarted);
    on<VarkQuestionAnswered>(_onQuestionAnswered);
    on<VarkAssessmentCompleted>(_onAssessmentCompleted);
    on<VarkMLPredictionReceived>(_onMLPredictionReceived);
    on<VarkMLPredictionFailed>(_onMLPredictionFailed);
    on<VarkLivePredictionRequested>(_onLivePredictionRequested);
    on<VarkLivePredictionReceived>(_onLivePredictionReceived);
  }

  Future<void> _onStarted(VarkStarted event, Emitter<VarkState> emit) async {
    emit(VarkLoading());

    // Reset Cubit state for new quiz
    varkCubit.reset();

    final result = await getVarkQuestions();

    result.fold(
      (failure) => emit(VarkError(failure.message)),
      (questions) => emit(
        VarkQuestionsLoaded(questions: questions, currentIndex: 0, answers: {}),
      ),
    );
  }

  Future<void> _onQuestionAnswered(
    VarkQuestionAnswered event,
    Emitter<VarkState> emit,
  ) async {
    final currentState = state;
    if (currentState is VarkQuestionsLoaded) {
      // Convert VarkType to letter string for storage
      final updatedAnswers = Map<String, String>.from(currentState.answers)
        ..[event.questionId] = event.selectedOption.letter;

      print(
        'DEBUG BLOC: Answer added - questionId: ${event.questionId}, selectedOption: ${event.selectedOption.letter}',
      );
      print('DEBUG BLOC: Updated answers map: $updatedAnswers');

      final nextIndex = currentState.currentIndex + 1;

      if (nextIndex < currentState.questions.length) {
        // Calculate temporary scores for live prediction
        final scoresResult = await calculateVarkScores(updatedAnswers);

        scoresResult.fold(
          (failure) => null, // Silently fail for live prediction
          (scores) {
            print(
              'DEBUG BLOC: Live scores calculated - V:${scores.scores[VarkType.visual]}, A:${scores.scores[VarkType.auditory]}, R:${scores.scores[VarkType.readWrite]}, K:${scores.scores[VarkType.kinesthetic]}',
            );
            // Trigger live ML prediction after each answer
            add(
              VarkLivePredictionRequested(
                visualScore: scores.scores[VarkType.visual] ?? 0,
                auditoryScore: scores.scores[VarkType.auditory] ?? 0,
                readingScore: scores.scores[VarkType.readWrite] ?? 0,
                kinestheticScore: scores.scores[VarkType.kinesthetic] ?? 0,
              ),
            );
          },
        );

        emit(
          currentState.copyWith(
            currentIndex: nextIndex,
            answers: updatedAnswers,
          ),
        );
      } else {
        // Calculate scores - use updatedAnswers directly (no params wrapper)
        final scoresResult = await calculateVarkScores(updatedAnswers);

        scoresResult.fold((failure) => emit(VarkError(failure.message)), (
          scores,
        ) {
          print(
            'DEBUG BLOC: Final scores - V:${scores.scores[VarkType.visual]}, A:${scores.scores[VarkType.auditory]}, R:${scores.scores[VarkType.readWrite]}, K:${scores.scores[VarkType.kinesthetic]}',
          );
          add(
            VarkAssessmentCompleted(
              visualScore: scores.scores[VarkType.visual]!,
              auditoryScore: scores.scores[VarkType.auditory]!,
              readingScore: scores.scores[VarkType.readWrite]!,
              kinestheticScore: scores.scores[VarkType.kinesthetic]!,
            ),
          );
        });
      }
    }
  }

  Future<void> _onAssessmentCompleted(
    VarkAssessmentCompleted event,
    Emitter<VarkState> emit,
  ) async {
    // Emit processing state
    emit(
      VarkMLProcessing(
        traditionalScores: {
          'visual': event.visualScore,
          'auditory': event.auditoryScore,
          'reading': event.readingScore,
          'kinesthetic': event.kinestheticScore,
        },
      ),
    );

    // Call Cubit to get ML prediction
    await varkCubit.getPrediction(
      visualScore: event.visualScore,
      auditoryScore: event.auditoryScore,
      readingScore: event.readingScore,
      kinestheticScore: event.kinestheticScore,
    );
  }

  void _onMLPredictionReceived(
    VarkMLPredictionReceived event,
    Emitter<VarkState> emit,
  ) {
    // Create VarkQuizResult from traditional scores
    final varkScores = <VarkType, int>{
      VarkType.visual: event.traditionalScores['visual'] ?? 0,
      VarkType.auditory: event.traditionalScores['auditory'] ?? 0,
      VarkType.readWrite: event.traditionalScores['reading'] ?? 0,
      VarkType.kinesthetic: event.traditionalScores['kinesthetic'] ?? 0,
    };

    final dominantStyle = varkScores.entries
        .reduce((max, e) => e.value > max.value ? e : max)
        .key;

    final total = varkScores.values.fold(0, (sum, v) => sum + v);
    final results = varkScores.entries.map((e) {
      final percentage = total > 0 ? (e.value / total) * 100.0 : 0.0;
      return LearningStyleResult(
        type: e.key,
        score: e.value,
        percentage: percentage,
      );
    }).toList();

    final result = VarkQuizResult(
      scores: varkScores,
      results: results,
      dominantStyle: dominantStyle,
      totalQuestions: total,
    );

    emit(
      VarkMLSuccess(
        prediction: event.prediction,
        traditionalScores: event.traditionalScores,
        result: result,
      ),
    );
  }

  void _onMLPredictionFailed(
    VarkMLPredictionFailed event,
    Emitter<VarkState> emit,
  ) {
    emit(VarkError(event.message));
  }

  /// Handler untuk request live prediction setelah setiap jawaban
  Future<void> _onLivePredictionRequested(
    VarkLivePredictionRequested event,
    Emitter<VarkState> emit,
  ) async {
    // Call Cubit to get live ML prediction
    await varkCubit.getPrediction(
      visualScore: event.visualScore,
      auditoryScore: event.auditoryScore,
      readingScore: event.readingScore,
      kinestheticScore: event.kinestheticScore,
    );
  }

  /// Handler untuk menerima live prediction dan update state
  void _onLivePredictionReceived(
    VarkLivePredictionReceived event,
    Emitter<VarkState> emit,
  ) {
    final currentState = state;
    if (currentState is VarkQuestionsLoaded) {
      emit(currentState.copyWith(livePrediction: event.prediction));
    }
  }

  @override
  Future<void> close() {
    _cubitSubscription?.cancel();
    return super.close();
  }
}

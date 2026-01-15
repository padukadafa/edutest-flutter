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
        // Emit success state dengan ML prediction
        if (state is VarkMLProcessing) {
          final processingState = state as VarkMLProcessing;
          add(
            VarkMLPredictionReceived(
              prediction: cubitState.prediction,
              traditionalScores: processingState.traditionalScores,
            ),
          );
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
  }

  Future<void> _onStarted(VarkStarted event, Emitter<VarkState> emit) async {
    emit(VarkLoading());

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

      final nextIndex = currentState.currentIndex + 1;

      if (nextIndex < currentState.questions.length) {
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

  @override
  Future<void> close() {
    _cubitSubscription?.cancel();
    return super.close();
  }
}

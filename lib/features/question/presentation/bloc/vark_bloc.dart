import 'package:edutest/features/question/domain/models/vark_question_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vark_event.dart';
import 'vark_state.dart';
import '../../data/vark_questions.dart';

class VarkBloc extends Bloc<VarkEvent, VarkState> {
  VarkBloc() : super(const VarkState()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SelectAnswer>(_onSelectAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<GoToQuestion>(_onGoToQuestion);
    on<ResetVark>(_onResetVark);
    on<SubmitQuiz>(_onSubmitQuiz);
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<VarkState> emit) {
    emit(state.copyWith(status: VarkStatus.loading));

    final questions = VarkQuestions.questions;

    emit(
      state.copyWith(
        status: VarkStatus.ready,
        questions: questions,
        currentQuestionIndex: 0,
        answers: {},
        score: {},
      ),
    );
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<VarkState> emit) {
    if (state.status != VarkStatus.ready) return;

    final updatedAnswers = Map<int, VarkType>.from(state.answers);
    updatedAnswers[state.currentQuestionIndex] = event.type;

    final updatedScore = Map<String, int>.from(state.score);
    final letter = event.type.letter;
    updatedScore[letter] = (updatedScore[letter] ?? 0) + 1;

    emit(state.copyWith(answers: updatedAnswers, score: updatedScore));
  }

  void _onNextQuestion(NextQuestion event, Emitter<VarkState> emit) {
    if (state.status != VarkStatus.ready) return;
    if (state.currentQuestionIndex < state.questions.length - 1) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<VarkState> emit) {
    if (state.status != VarkStatus.ready) return;
    if (state.currentQuestionIndex > 0) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1),
      );
    }
  }

  void _onGoToQuestion(GoToQuestion event, Emitter<VarkState> emit) {
    if (state.status != VarkStatus.ready) return;
    if (event.index >= 0 && event.index < state.questions.length) {
      emit(state.copyWith(currentQuestionIndex: event.index));
    }
  }

  void _onResetVark(ResetVark event, Emitter<VarkState> emit) {
    emit(const VarkState());
  }

  void _onSubmitQuiz(SubmitQuiz event, Emitter<VarkState> emit) {
    if (state.status != VarkStatus.ready) return;

    final scores = <VarkType, int>{};
    for (var entry in state.score.entries) {
      switch (entry.key) {
        case 'V':
          scores[VarkType.visual] = entry.value;
          break;
        case 'A':
          scores[VarkType.auditory] = entry.value;
          break;
        case 'R':
          scores[VarkType.readWrite] = entry.value;
          break;
        case 'K':
          scores[VarkType.kinesthetic] = entry.value;
          break;
      }
    }

    final totalAnswers = scores.values.fold(0, (a, b) => a + b);

    final results = scores.entries.map((entry) {
      return LearningStyleResult(
        type: entry.key,
        score: entry.value,
        percentage: totalAnswers > 0 ? (entry.value / totalAnswers) * 100 : 0,
      );
    }).toList()..sort((a, b) => b.score.compareTo(a.score));

    final dominantStyle = results.isNotEmpty
        ? results.first.type
        : VarkType.visual;

    emit(
      state.copyWith(
        status: VarkStatus.completed,
        quizResult: VarkQuizResult(
          scores: scores,
          results: results,
          dominantStyle: dominantStyle,
          totalQuestions: state.questions.length,
        ),
      ),
    );
  }
}

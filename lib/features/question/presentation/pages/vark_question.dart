import 'package:edutest/core/routes/route_name.dart';
import 'package:edutest/shared/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vark_bloc.dart';
import '../bloc/vark_event.dart';
import '../bloc/vark_state.dart';

class VarkQuestionPage extends StatelessWidget {
  const VarkQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VarkBloc, VarkState>(
      listener: (context, state) {
        if (state.isFinished && state.quizResult != null) {
          Navigator.pushReplacementNamed(
            context,
            RouteName.varkResult,
            arguments: state.quizResult,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName(RouteName.varkIntro),
              );
            },
          ),

          centerTitle: true,
          title: const Column(
            children: [
              Text(
                'Prior Knowledge',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Quiz', style: TextStyle(fontSize: 12)),
            ],
          ),
          actions: [_buildProgressIndicator()],
        ),
        body: BlocBuilder<VarkBloc, VarkState>(
          builder: (context, state) {
            switch (state.status) {
              case VarkStatus.initial:
              case VarkStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case VarkStatus.error:
                return _buildErrorState(context, state.errorMessage);
              case VarkStatus.ready:
              case VarkStatus.inProgress:
              case VarkStatus.completed:
                return _buildQuizContent(context, state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: BlocBuilder<VarkBloc, VarkState>(
          builder: (context, state) {
            return Text(
              '${state.currentQuestionIndex + 1}/${state.totalQuestions}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<VarkBloc>().add(LoadQuestions()),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, VarkState state) {
    final question = state.currentQuestion;
    if (question == null) {
      return const Center(child: Text('Pertanyaan tidak ditemukan'));
    }

    return Column(
      children: [
        // Progress bar
        _buildProgressBar(state),

        // Question navigation dots
        _buildQuestionDots(context, state),

        // Question content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: QuestionCard(
              question: question,
              questionIndex: state.currentQuestionIndex + 1,
              total: state.totalQuestions,
              selectedType: state.currentAnswer,
              onSelect: (type) {
                context.read<VarkBloc>().add(SelectAnswer(type));
              },
            ),
          ),
        ),

        // Navigation buttons
        _buildNavigationButtons(context, state),
      ],
    );
  }

  Widget _buildProgressBar(VarkState state) {
    return LinearProgressIndicator(
      value: state.progress,
      minHeight: 4,
      backgroundColor: Colors.grey.shade200,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

  Widget _buildQuestionDots(BuildContext context, VarkState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            state.totalQuestions,
            (index) => GestureDetector(
              onTap: () {
                if (index != state.currentQuestionIndex) {
                  context.read<VarkBloc>().add(GoToQuestion(index));
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getDotColor(index, state),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getDotColor(int index, VarkState state) {
    if (index == state.currentQuestionIndex) {
      return Colors.blue;
    }
    if (state.answers.containsKey(index)) {
      return Colors.green;
    }
    return Colors.grey.shade300;
  }

  Widget _buildNavigationButtons(BuildContext context, VarkState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state.canGoPrevious
                    ? () => context.read<VarkBloc>().add(PreviousQuestion())
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Sebelumnya'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: state.canGoNext
                    ? () => context.read<VarkBloc>().add(NextQuestion())
                    : (state.allAnswered
                          ? () => context.read<VarkBloc>().add(SubmitQuiz())
                          : null),
                icon: Text(state.canGoNext ? 'Selanjutnya' : 'Selesai'),
                label: state.canGoNext
                    ? const Icon(Icons.arrow_forward)
                    : const Icon(Icons.check),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/domain/entities/vark_test_result.dart';
import 'package:edutest/domain/repositories/vark_result_repository.dart';
import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:edutest/features/question/presentation/cubit/vark_cubit.dart';
import 'package:edutest/features/question/presentation/pages/vark_result_page.dart';
import 'package:edutest/injection/injection_container.dart' as di;
import 'package:edutest/shared/widgets/question_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VarkQuestionPage extends StatefulWidget {
  const VarkQuestionPage({super.key});

  @override
  State<VarkQuestionPage> createState() => _VarkQuestionPageState();
}

class _VarkQuestionPageState extends State<VarkQuestionPage>
    with TickerProviderStateMixin {
  VarkType? _selectedType;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateToNextQuestion(int newIndex) {
    if (newIndex != _lastIndex) {
      _lastIndex = newIndex;
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<bool> _onWillPop(BuildContext context, VarkState state) async {
    if (state is VarkQuestionsLoaded && state.currentIndex > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Keluar dari Kuis?'),
          content: const Text(
            'Progress Anda akan hilang. Yakin ingin keluar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lanjut'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
              child: const Text('Keluar'),
            ),
          ],
        ),
      );
      return confirmed ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final state = context.read<VarkBloc>().state;
        _onWillPop(context, state).then((confirmed) {
          if (confirmed) {
            Navigator.of(context).pop();
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: const Column(
            children: [
              Text('VARK Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Learning Style', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        body: BlocConsumer<VarkBloc, VarkState>(
          listener: (context, state) async {
            if (state is VarkMLProcessing) {
              _showProcessingDialog(context);
            }
            if (state is VarkMLSuccess) {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }

              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                final repository = di.sl<VarkResultRepository>();
                final testResult = VarkTestResult(
                  id: '',
                  uid: uid,
                  dominantStyle: VarkTypeResultExtension.fromString(
                    state.prediction.predictedStyle,
                  ),
                  scores: {
                    'V': state.traditionalScores['visual'] ?? 0,
                    'A': state.traditionalScores['auditory'] ?? 0,
                    'R': state.traditionalScores['reading'] ?? 0,
                    'K': state.traditionalScores['kinesthetic'] ?? 0,
                  },
                  mlPrediction: state.prediction.predictedStyle,
                  mlConfidence: state.prediction.confidencePercentage,
                  completedAt: DateTime.now(),
                );

                await repository.saveResult(testResult);
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VarkResultPage(
                    result: state.result,
                    prediction: state.prediction,
                    traditionalScores: state.traditionalScores,
                  ),
                ),
              );
            }
            if (state is VarkError) {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Terjadi Kesalahan'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VarkLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VarkQuestionsLoaded) {
              final question = state.questions[state.currentIndex];
              final progress = (state.currentIndex + 1) / state.questions.length;

              _animateToNextQuestion(state.currentIndex);

              return Column(
                children: [
                  _buildProgressBar(progress, state.currentIndex + 1, state.questions.length),
                  Expanded(
                    child: FadeTransition(
                      opacity: _animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(_animation),
                        child: QuestionCard(
                          question: question,
                          questionIndex: state.currentIndex + 1,
                          total: state.questions.length,
                          selectedType: _selectedType,
                          onSelect: (type) {
                            setState(() => _selectedType = type);
                          },
                        ),
                      ),
                    ),
                  ),
                  _buildNextButton(
                    context,
                    question,
                    state.currentIndex,
                    state.questions.length,
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    VarkQuestion question,
    int currentIndex,
    int totalQuestions,
  ) {
    final isLastQuestion = currentIndex == totalQuestions - 1;
    final isAnswerSelected = _selectedType != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isAnswerSelected
              ? () {
                  context.read<VarkBloc>().add(
                        VarkQuestionAnswered(
                          questionId: question.id.toString(),
                          selectedOption: _selectedType!,
                        ),
                      );
                  setState(() => _selectedType = null);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            isLastQuestion ? 'Selesai' : 'Selanjutnya',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, int current, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pertanyaan $current dari $total',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Icon(
                        Icons.auto_awesome,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Menganalisis Hasil Anda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Memproses dengan Machine Learning...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

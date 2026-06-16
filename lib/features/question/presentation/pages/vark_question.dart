import 'package:edutest/core/routes/route_name.dart';
import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:edutest/features/question/presentation/cubit/vark_cubit.dart';
import 'package:edutest/shared/widgets/question_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/domain/entities/vark_test_result.dart';
import 'package:edutest/injection/injection_container.dart' as di;
import 'package:edutest/domain/repositories/vark_result_repository.dart';

class VarkQuestionPage extends StatefulWidget {
  const VarkQuestionPage({super.key});

  @override
  State<VarkQuestionPage> createState() => _VarkQuestionPageState();
}

class _VarkQuestionPageState extends State<VarkQuestionPage> {
  VarkType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            final varkCubit = context.read<VarkCubit>();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => PopScope(
                canPop: false,
                child: BlocProvider.value(
                  value: varkCubit, // 🔑 FIX UTAMA
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          const SizedBox(height: 24),
                          const Text(
                            'Menganalisis Hasil Anda',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<VarkCubit, VarkCubitState>(
                            builder: (_, cubitState) {
                              if (cubitState is VarkCubitPredicting) {
                                return Text(cubitState.message);
                              }
                              return const Text(
                                'Memproses dengan Machine Learning...',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (state is VarkMLSuccess) {
            Navigator.of(context).pop();

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

            Navigator.pushReplacementNamed(
              context,
              RouteName.varkResult,
              arguments: {
                'prediction': state.prediction,
                'traditionalScores': state.traditionalScores,
                'result': state.result,
              },
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

            return QuestionCard(
              question: question,
              questionIndex: state.currentIndex + 1,
              total: state.questions.length,
              selectedType: _selectedType,
              onSelect: (type) {
                setState(() => _selectedType = type);

                context.read<VarkBloc>().add(
                  VarkQuestionAnswered(
                    questionId: question.id.toString(),
                    selectedOption: type,
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

import 'package:edutest/core/routes/route_name.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:edutest/features/question/presentation/cubit/vark_cubit.dart';
import 'package:edutest/shared/widgets/info_card_question.dart';
import 'package:edutest/shared/widgets/primary_button.dart';
import 'package:edutest/injection/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VarkIntroPage extends StatelessWidget {
  const VarkIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<VarkCubit>()..checkServerHealth(),
      child: const VarkIntroPageContent(),
    );
  }
}

class VarkIntroPageContent extends StatelessWidget {
  const VarkIntroPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
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
      ),
      body: Column(
        children: [
          BlocBuilder<VarkCubit, VarkCubitState>(
            builder: (context, state) {
              if (state is VarkCubitConnecting) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.blue.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Menghubungkan ke ML Server...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is VarkCubitServerHealthy) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: state.isHealthy
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    border: Border(
                      bottom: BorderSide(
                        color: state.isHealthy
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        state.isHealthy
                            ? Icons.check_circle
                            : Icons.error_outline,
                        size: 18,
                        color: state.isHealthy
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isHealthy
                            ? 'ML Server Terhubung'
                            : 'ML Server Tidak Terhubung',
                        style: TextStyle(
                          fontSize: 13,
                          color: state.isHealthy
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!state.isHealthy) ...[
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context.read<VarkCubit>().checkServerHealth();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              if (state is VarkCubitConnectionError) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.red.shade200),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<VarkCubit>().checkServerHealth();
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Coba Hubungkan Lagi'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            side: BorderSide(color: Colors.red.shade700),
                            foregroundColor: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),

                  // Icon and title
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade300.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Quiz Gaya Belajar VARK',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Temukan gaya belajar Anda! Jawab 16 pertanyaan sederhana untuk mengetahui apakah Anda lebih cocok dengan gaya Visual, Auditory, Read/Write, atau Kinesthetic.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info cards
                  InfoCardQuestion(
                    icon: Icons.access_time,
                    text: 'Waktu: ~5 menit',
                    backgroundColor: Colors.blue.shade100,
                  ),
                  const SizedBox(height: 12),
                  InfoCardQuestion(
                    icon: Icons.help_outline,
                    text: '16 Pertanyaan',
                    backgroundColor: Colors.amber.shade100,
                  ),
                  const SizedBox(height: 12),
                  InfoCardQuestion(
                    icon: Icons.analytics,
                    text: 'Hasil Akurat dengan ML',
                    backgroundColor: Colors.green.shade100,
                  ),

                  const Spacer(),

                  BlocBuilder<VarkCubit, VarkCubitState>(
                    builder: (context, cubitState) {
                      // Check if server is healthy
                      final isServerHealthy =
                          cubitState is VarkCubitServerHealthy &&
                          cubitState.isHealthy;

                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: PrimaryButton(
                              text: 'Mulai Kuis',
                              style: ElevatedButton.styleFrom(),
                              onPressed: isServerHealthy
                                  ? () {
                                      // Start VARK assessment
                                      context.read<VarkBloc>().add(
                                        VarkStarted(),
                                      );

                                      // Navigate to question page
                                      Navigator.pushNamed(
                                        context,
                                        RouteName.varkQuestion,
                                        arguments: {
                                          'varkBloc': context.read<VarkBloc>(),
                                          'varkCubit': context
                                              .read<VarkCubit>(),
                                        },
                                      );
                                    }
                                  : () {}, // Disable if server not healthy
                            ),
                          ),

                          // Warning message jika server tidak terhubung
                          if (!isServerHealthy)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Hubungkan ke ML Server terlebih dahulu',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

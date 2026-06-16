import 'package:edutest/core/routes/route_name.dart';
import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:edutest/features/question/presentation/cubit/vark_cubit.dart';
import 'package:edutest/features/question/presentation/pages/vark_question.dart';
import 'package:edutest/shared/widgets/info_card_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VarkIntroPage extends StatelessWidget {
  const VarkIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const VarkIntroPageContent();
  }
}

class VarkIntroPageContent extends StatelessWidget {
  const VarkIntroPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
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
            _buildServerStatusBanner(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(),
                    _buildHeaderIcon(),
                    const SizedBox(height: 32),
                    const Text(
                      'Quiz Gaya Belajar VARK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                    _buildInfoCards(),
                    const Spacer(),
                    _buildStartButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerStatusBanner(BuildContext context) {
    return BlocBuilder<VarkCubit, VarkCubitState>(
      builder: (context, state) {
        if (state is VarkCubitConnecting) {
          return _buildBanner(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.blue.shade700),
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
            backgroundColor: Colors.blue.shade50,
            borderColor: Colors.blue.shade200,
          );
        }

        if (state is VarkCubitServerHealthy) {
          return _buildBanner(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state.isHealthy ? Icons.check_circle : Icons.error_outline,
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
                    child: const Text('Coba Lagi', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ],
            ),
            backgroundColor: state.isHealthy
                ? Colors.green.shade50
                : Colors.red.shade50,
            borderColor: state.isHealthy
                ? Colors.green.shade200
                : Colors.red.shade200,
          );
        }

        if (state is VarkCubitConnectionError) {
          return _buildBanner(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(fontSize: 13, color: Colors.red.shade700),
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
            backgroundColor: Colors.red.shade50,
            borderColor: Colors.red.shade200,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBanner({
    required Widget child,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: child,
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
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
      child: const Icon(Icons.psychology, size: 60, color: Colors.white),
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return BlocBuilder<VarkCubit, VarkCubitState>(
      builder: (context, cubitState) {
        final isServerHealthy = cubitState is VarkCubitServerHealthy &&
            cubitState.isHealthy;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isServerHealthy
                    ? () {
                        final varkBloc = context.read<VarkBloc>();
                        final varkCubit = context.read<VarkCubit>();
                        varkBloc.add(VarkStarted());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: varkBloc),
                                BlocProvider.value(value: varkCubit),
                              ],
                              child: const VarkQuestionPage(),
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mulai Kuis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
    );
  }
}

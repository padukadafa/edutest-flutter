import 'package:edutest/core/routes/route_name.dart';
import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:edutest/shared/widgets/info_card_question.dart';
import 'package:edutest/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VarkIntroPage extends StatelessWidget {
  const VarkIntroPage({super.key});

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
      body: Padding(
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
              text: 'Hasil Akurat',
              backgroundColor: Colors.green.shade100,
            ),

            const Spacer(),

            // Start button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: PrimaryButton(
                text: 'Mulai Kuis',
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  final bloc = context.read<VarkBloc>();
                  Navigator.pushNamed(
                    context,
                    RouteName.varkQuestion,
                    arguments: bloc,
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

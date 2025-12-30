import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/primary_button.dart';

class VarkQuestionPage extends StatelessWidget {
  const VarkQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VARK Test")),
      body: BlocBuilder<VarkBloc, VarkState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Question ${state.index + 1}"),
                const SizedBox(height: 24),

                PrimaryButton(
                  text: "Visual",
                  onPressed: () {
                    context.read<VarkBloc>().add(SelectAnswer("Visual"));
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: "Auditory",
                  onPressed: () {
                    context.read<VarkBloc>().add(SelectAnswer("Auditory"));
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: "Read/Write",
                  onPressed: () {
                    context.read<VarkBloc>().add(SelectAnswer("Read"));
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: "Kinesthetic",
                  onPressed: () {
                    context.read<VarkBloc>().add(SelectAnswer("Kinesthetic"));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

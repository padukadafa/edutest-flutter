import 'package:edutest/features/question/presentation/bloc/vark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VarkResultPage extends StatelessWidget {
  const VarkResultPage({super.key, required result});

  @override
  Widget build(BuildContext context) {
    final state = context.read<VarkBloc>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          "Your VARK Score:\n${state.score}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

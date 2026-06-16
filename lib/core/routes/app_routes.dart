import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection/injection.dart';
import '../../features/question/presentation/pages/vark_intro_pages.dart';
import '../../features/question/presentation/pages/vark_question.dart';
import '../../features/question/presentation/pages/vark_result_page.dart';
import '../../features/question/presentation/bloc/vark_bloc.dart';
import '../../features/question/presentation/cubit/vark_cubit.dart';
import '../../features/question/data/models/vark_question_model.dart';
import '../../features/question/domain/entities/ml_prediction.dart';
import 'route_name.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.varkIntro:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<VarkBloc>()),
              BlocProvider(create: (_) => sl<VarkCubit>()..checkServerHealth()),
            ],
            child: const VarkIntroPage(),
          ),
        );

      case RouteName.varkQuestion:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<VarkBloc>()),
              BlocProvider.value(value: context.read<VarkCubit>()),
            ],
            child: const VarkQuestionPage(),
          ),
        );

      case RouteName.varkResult:
        final args = settings.arguments;

        if (args is! Map<String, dynamic>) {
          return _errorPage('Invalid arguments for VarkResultPage');
        }

        final result = args['result'];
        if (result is! VarkQuizResult) {
          return _errorPage('Result data is missing or invalid');
        }

        final prediction = args['prediction'] as MLPrediction?;

        return MaterialPageRoute(
          builder: (_) => VarkResultPage(result: result, prediction: prediction),
        );

      default:
        return _errorPage('Page not found');
    }
  }

  static MaterialPageRoute _errorPage(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message, textAlign: TextAlign.center)),
      ),
    );
  }
}

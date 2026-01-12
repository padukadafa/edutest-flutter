import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/presentation/bloc/vark_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection/injection.dart';
import '../../features/question/presentation/pages/vark_intro_pages.dart';
import '../../features/question/presentation/pages/vark_question.dart';
import '../../features/question/presentation/pages/vark_result_page.dart';
import '../../features/question/presentation/bloc/vark_bloc.dart';
import 'route_name.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.varkIntro:
        final bloc = sl<VarkBloc>();
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (_) => bloc, child: const VarkIntroPage()),
        );

      case RouteName.varkQuestion:
        final bloc = settings.arguments;

        if (bloc is! VarkBloc) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text(
                  'VarkBloc tidak ditemukan.\nAkses halaman ini harus dari Intro.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc..add(LoadQuestions()),
            child: const VarkQuestionPage(),
          ),
        );

      case RouteName.varkResult:
        final result = settings.arguments as VarkQuizResult;
        return MaterialPageRoute(
          builder: (_) => VarkResultPage(result: result),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

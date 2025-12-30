import 'package:edutest/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:edutest/shared/pages/splash_screen.dart';
import 'package:edutest/features/auth/presentation/pages/signin_page.dart';
import 'package:edutest/features/question/presentation/pages/vark_intro_pages.dart';
import 'package:edutest/features/question/presentation/pages/vark_question.dart';
import 'package:edutest/features/question/presentation/pages/vark_result_page.dart';

import 'route_name.dart';

class AppRoutes {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteName.signin:
        return MaterialPageRoute(builder: (_) => const SigninPage());

      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case RouteName.varkIntro:
        return MaterialPageRoute(builder: (_) => const VarkIntroPage());

      case RouteName.varkQuestion:
        return MaterialPageRoute(builder: (_) => const VarkQuestionPage());

      case RouteName.varkResult:
        // SIAP TERIMA ARGUMENT (HASIL Machine Learning)
        final args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => VarkResultPage(result: args?['result']),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Page not found'))),
    );
  }
}

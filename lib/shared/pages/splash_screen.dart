import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, RouteName.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset('assets/images/logo_edutest.png', width: 90),

            const SizedBox(height: 16),

            // TEXT
            const Text(
              'edutest',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B2C5D), // sesuaikan app color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

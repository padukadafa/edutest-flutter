import 'package:flutter/material.dart';
import '../../../../../shared/widgets/primary_button.dart';
import '../../../../../core/routes/route_name.dart';

class VarkIntroPage extends StatelessWidget {
  const VarkIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("VARK Learning Test", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Start Test",
              onPressed: () {
                Navigator.pushNamed(context, RouteName.varkQuestion);
              },
            ),
          ],
        ),
      ),
    );
  }
}

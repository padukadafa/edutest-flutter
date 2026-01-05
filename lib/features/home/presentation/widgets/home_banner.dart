import 'package:flutter/material.dart';
import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/shared/widgets/container_circle.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ContainerCircle(
        height: 140,
        width: MediaQuery.of(context).size.width,
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello Hefri,',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Let's Detection Learning Style",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/kazuha.jpeg'),
            ),
          ],
        ),
      ),
    );
  }
}

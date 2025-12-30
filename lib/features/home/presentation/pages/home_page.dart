import 'package:flutter/material.dart';
import '../widgets/home_banner.dart';
import '../widgets/section_title.dart';
import '../widgets/home_menu_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 12),
          HomeBanner(),
          SizedBox(height: 24),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SectionTitle(title: 'Improve Your Skills'),
          ),

          SizedBox(height: 16),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: HomeMenuGrid(),
            ),
          ),
        ],
      ),
    );
  }
}

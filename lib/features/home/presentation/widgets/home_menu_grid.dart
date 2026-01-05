import 'package:edutest/core/routes/route_name.dart';
import 'package:flutter/material.dart';

class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuItem(
        id: 'prior',
        title: 'Prior Knowledge',
        subtitle: '16 Soal',
        image: 'assets/images/prior_knowledge.png',
      ),
      _MenuItem(
        id: 'data_mining',
        title: 'Data Mining',
        subtitle: '15 Soal',
        image: 'assets/images/data_mining.png',
      ),
      _MenuItem(
        id: 'ecommerce',
        title: 'E-Commerce',
        subtitle: '25 Soal',
        image: 'assets/images/ecommerce.png',
      ),
      _MenuItem(
        id: 'ai',
        title: 'AI Engineer',
        subtitle: '18 Soal',
        image: 'assets/images/ai_engineer.png',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 20,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = menus[index];

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.pushNamed(context, RouteName.varkIntro);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(flex: 5, child: Image.asset(item.image)),
                  const SizedBox(height: 20),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;

  _MenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

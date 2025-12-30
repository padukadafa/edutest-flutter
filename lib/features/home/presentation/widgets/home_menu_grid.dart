import 'package:flutter/material.dart';

class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuItem(
        title: 'Prior Knowledge',
        subtitle: '16 Soal',
        image: 'assets/images/image_1.png',
      ),
      _MenuItem(
        title: 'Data mining',
        subtitle: '15 Soal',
        image: 'assets/images/image_2.png',
      ),
      _MenuItem(
        title: 'E-Commerce',
        subtitle: '25 Soal',
        image: 'assets/images/image_3.png',
      ),
      _MenuItem(
        title: 'AI Engineer',
        subtitle: '18 Soal',
        image: 'assets/images/image_4.png',
      ),
    ];

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = menus[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(item.image, height: 80),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  final String title;
  final String subtitle;
  final String image;

  _MenuItem({required this.title, required this.subtitle, required this.image});
}

import 'package:flutter/material.dart';

import 'package:edutest/features/home/presentation/pages/home_page.dart';
import 'package:edutest/features/discuss/presentation/pages/discuss_page.dart';
import 'package:edutest/features/message/presentation/pages/message_page.dart';
import 'package:edutest/features/settings/presentation/pages/settings_page.dart';
import 'bottom_menu_nav.dart';

class MenuNavShell extends StatefulWidget {
  const MenuNavShell({super.key});

  @override
  State<MenuNavShell> createState() => _MenuNavShellState();
}

class _MenuNavShellState extends State<MenuNavShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DiscussPage(),
    MessagePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomMenuNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/shared/widgets/nav_icon.dart';

class BottomMenuNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomMenuNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      items: [
        BottomNavigationBarItem(
          icon: navIcon(
            asset: 'assets/svg/home.svg',
            isActive: currentIndex == 0,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: navIcon(
            asset: 'assets/svg/discuss.svg',
            isActive: currentIndex == 1,
          ),
          label: 'Discuss',
        ),
        BottomNavigationBarItem(
          icon: navIcon(
            asset: 'assets/svg/message.svg',
            isActive: currentIndex == 2,
          ),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: navIcon(
            asset: 'assets/svg/setting.svg',
            isActive: currentIndex == 3,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}

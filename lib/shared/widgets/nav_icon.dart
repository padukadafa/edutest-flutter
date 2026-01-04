import 'package:edutest/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget navIcon({required String asset, required bool isActive}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: isActive
          ? AppColors.primary.withOpacity(0.15)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: SvgPicture.asset(
      asset,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.primary : AppColors.grey,
        BlendMode.srcIn,
      ),
    ),
  );
}

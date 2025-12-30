import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edutest/core/themes/app_colors.dart';

class AppTextStyle {
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle get bodyText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGray,
  );

  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}

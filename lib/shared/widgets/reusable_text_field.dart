import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  const ReusableTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.05),
        suffixIcon: suffixIcon,
        enabledBorder: _border(),
        focusedBorder: _border(width: 2),
      ),
    );
  }

  OutlineInputBorder _border({double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.primary, width: width),
    );
  }
}

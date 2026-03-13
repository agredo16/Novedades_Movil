import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static const TextStyle xs = TextStyle(
    fontSize: 12, color: AppColors.gray500);

  static const TextStyle sm = TextStyle(
    fontSize: 14, color: AppColors.gray700);

  static const TextStyle base = TextStyle(
    fontSize: 16, color: AppColors.gray900);

  static const TextStyle lg = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.gray900);

  static const TextStyle xl = TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold,
    color: AppColors.gray900);

  static const TextStyle xl2 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold,
    color: AppColors.gray900);

  // Helpers
  static TextStyle get smGray => sm.copyWith(color: AppColors.gray500);
  static TextStyle get smPrimary => sm.copyWith(color: AppColors.primary);
  static TextStyle get baseBold => base.copyWith(fontWeight: FontWeight.bold);
  static TextStyle get lgWhite => lg.copyWith(color: AppColors.white);
}
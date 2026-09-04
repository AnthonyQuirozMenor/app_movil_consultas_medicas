import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle screenTitle = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle brandName = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: 1.1,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 15.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle textLink = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle chipText = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
  );
}

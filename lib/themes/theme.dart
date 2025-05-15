import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'additional_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.scaffoldLight,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryBlue,
    onPrimary: Colors.white,
    secondary: AppColors.secondBlue,
    onSecondary: AppColors.textForLight,
    error: AppColors.errorRedLight,
    // surface: AppColors.fourthBlue,
    onSurface: AppColors.textForLight,
    surface: AppColors.scaffoldLight,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.textForLight,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textForLight,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.textForLight,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textForLight,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleSmall: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.scaffoldLight,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textForLight,
    ),
    iconTheme: IconThemeData(
      color: AppColors.textForLight,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.fourthBlue,
    selectedItemColor: AppColors.primaryBlue,
    unselectedItemColor: AppColors.secondGrey,
    showSelectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
).copyWith(
  // Добавляем расширение AdditionalColors с дополнительными цветами для светлой темы.
  extensions: <ThemeExtension<dynamic>>[
    AdditionalColors(
      scaffold: AppColors.scaffoldLight,
      text: AppColors.scaffoldLight,
      primary: AppColors.primaryBlue,
      secondary: AppColors.secondBlue,
      tertiary: AppColors.thirdBlue,
      successGreen: AppColors.primaryGreenLight,
      errorRed: AppColors.errorRedLight,
      alertRed: AppColors.alertRedLight,
      gold: AppColors.goldLight,
      primaryGrey: AppColors.primaryGrey,
      inactiveButtons: AppColors.secondGrey,
      greetingText: AppColors.primaryBlue,
      ratingCard: AppColors.scaffoldLight,
      firstLevel: AppColors.fourthBlue,
      secondLevel: AppColors.thirdBlue,
      secback: AppColors.primaryBlue,
      hint: AppColors.primaryBlue,
      fifth: AppColors.fifthBlue,
    ),
  ],
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.scaffoldDark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryPurple,
    onPrimary: AppColors.textForDark,
    secondary: AppColors.thirdPurple,
    onSecondary: AppColors.textForDark,
    error: AppColors.errorRedDark,
    surface: AppColors.thirdPurple,
    onSurface: AppColors.textForDark,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.textForDark,
    ),
    displayLarge: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryPurple,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textForDark,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.textForDark,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textForDark,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textForDark,
    ),
    titleMedium: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textForDark,
    ),
    titleSmall: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textForDark,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.scaffoldDark,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'IBMPlexSans',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textForDark,
    ),
    iconTheme: IconThemeData(
      color: AppColors.textForDark,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.primaryPurple,
    selectedItemColor: AppColors.thirdPurple,
    unselectedItemColor: Colors.white54,
    showSelectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
).copyWith(
  // Добавляем расширение AdditionalColors с дополнительными цветами для тёмной темы.
  extensions: <ThemeExtension<dynamic>>[
    AdditionalColors(
      scaffold: AppColors.scaffoldDark,
      text: AppColors.textForDark,
      primary: AppColors.primaryPurple,
      secondary: AppColors.secondPurple,
      tertiary: AppColors.thirdPurple,
      successGreen: AppColors.successGreenDark,
      errorRed: AppColors.errorRedDark,
      alertRed: AppColors.alertRedDark,
      gold: AppColors.goldDark,
      primaryGrey: AppColors.primaryGrey,
      inactiveButtons: AppColors.inactiveButtons,
      greetingText: AppColors.thirdPurple,
      ratingCard: AppColors.thirdPurple,
      firstLevel: AppColors.fourthPurple,
      secondLevel: AppColors.secondPurple,
      secback: AppColors.secondPurple,
      hint: AppColors.goldDark,
      fifth: AppColors.fifthPurple,
    ),
  ],
);
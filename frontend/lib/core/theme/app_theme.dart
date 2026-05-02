import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.dark(
      primary:    AppColors.primary,
      secondary:  AppColors.secondary,
      onPrimary:  AppColors.white,
      onSecondary: AppColors.white,
      onSurface:  AppColors.textPrimary,
      error:      AppColors.danger,
    ),


    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondary,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 24, fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),


    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.secondary,
      contentTextStyle: GoogleFonts.dmSans(color: AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
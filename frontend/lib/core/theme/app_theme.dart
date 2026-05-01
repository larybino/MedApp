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
      surface:    AppColors.surface,
      onPrimary:  AppColors.white,
      onSecondary: AppColors.white,
      onSurface:  AppColors.textPrimary,
      error:      AppColors.danger,
    ),

    // Tipografia
    textTheme: GoogleFonts.dmSansTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.syne(
        fontSize: 32, fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 24, fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
      titleLarge: GoogleFonts.syne(
        fontSize: 20, fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
      titleMedium: GoogleFonts.syne(
        fontSize: 16, fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: AppColors.white,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.syne(
        fontSize: 15, fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.syne(
        fontSize: 18, fontWeight: FontWeight.w800,
        color: AppColors.primary,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),

    // Botão primário
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: const StadiumBorder(),
        elevation: 0,
        textStyle: GoogleFonts.syne(
          fontSize: 15, fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // Botão outline
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 52),
        shape: const StadiumBorder(),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: GoogleFonts.syne(
          fontSize: 15, fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
      hintStyle: GoogleFonts.dmSans(
        color: AppColors.textMuted, fontSize: 14,
      ),
      labelStyle: GoogleFonts.dmSans(
        color: AppColors.textMuted, fontSize: 14,
      ),
      floatingLabelStyle: GoogleFonts.dmSans(
        color: AppColors.primary, fontSize: 12,
      ),
    ),

    // Divisor
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 0.5,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceAlt,
      contentTextStyle: GoogleFonts.dmSans(color: AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
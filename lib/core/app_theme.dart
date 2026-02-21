import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class FluxTheme {
  FluxTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FluxColors.bg01,
      primaryColor: FluxColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: FluxColors.primary,
        secondary: FluxColors.secondary,
        surface: FluxColors.bg02,
        error: FluxColors.danger,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
        bodyColor: FluxColors.textPrimary,
        displayColor: FluxColors.textPrimary,
      ).copyWith(
        displayLarge: GoogleFonts.orbitron(
          color: FluxColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          color: FluxColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          color: FluxColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: FluxColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: FluxColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          color: FluxColors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          color: FluxColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          color: FluxColors.textSecondary,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          color: FluxColors.textMuted,
          fontSize: 12,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          color: FluxColors.textMuted,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: FluxColors.bg02,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: FluxColors.bg04, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: FluxColors.bg01,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.orbitron(
          color: FluxColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: FluxColors.textSecondary),
      ),
      iconTheme: const IconThemeData(color: FluxColors.textSecondary, size: 20),
      dividerTheme: const DividerThemeData(
        color: FluxColors.bg04,
        thickness: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: FluxColors.primary,
        foregroundColor: FluxColors.bg01,
        elevation: 8,
      ),
    );
  }
}
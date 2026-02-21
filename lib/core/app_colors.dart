import 'package:flutter/material.dart';

class FluxColors {
  FluxColors._();

  static const Color primary       = Color(0xFF00D4FF);   // Cyan accent
  static const Color primaryDark   = Color(0xFF0099BB);
  static const Color secondary     = Color(0xFF7C3AED);   // Violet
  static const Color accent        = Color(0xFF00FFB3);   // Mint green
  static const Color warning       = Color(0xFFFFB347);   // Amber
  static const Color danger        = Color(0xFFFF4D6D);   // Rose red
  static const Color success       = Color(0xFF00FFB3);


  static const Color bg00          = Color(0xFF060912);   // Deepest
  static const Color bg01          = Color(0xFF0C1120);   // Main bg
  static const Color bg02          = Color(0xFF111827);   // Card bg
  static const Color bg03          = Color(0xFF1A2235);   // Elevated card
  static const Color bg04          = Color(0xFF243047);   // Hover / border


  static const Color textPrimary   = Color(0xFFEDF2FF);
  static const Color textSecondary = Color(0xFF8B9EC7);
  static const Color textMuted     = Color(0xFF4A5878);
  static const Color textAccent    = Color(0xFF00D4FF);

  static const List<Color> chartPalette = [
    Color(0xFF00D4FF),
    Color(0xFF7C3AED),
    Color(0xFF00FFB3),
    Color(0xFFFFB347),
    Color(0xFFFF4D6D),
    Color(0xFF60A5FA),
  ];

  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1A2235)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF4D6D), Color(0xFFFF8A65)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00FFB3), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

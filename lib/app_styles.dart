import 'package:flutter/material.dart';

/// Centralized style management for Gold Circle app
/// Import this file to access all colors, fonts, and text styles
class AppStyles {
  // Private constructor to prevent instantiation
  AppStyles._();

  // COLORS
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF4E8C1);
  static const Color goldDark = Color(0xFFB8941F);

  static const Color backgroundWhite = Colors.white;
  static const Color backgroundGrey = Color(0xFFF8F8F8);
  static const Color cardBackground = Colors.white;

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;
  static const Color textBlack = Colors.black;

  // Black and dark shades
  static const Color black = Color(0xFF000000);           // Pure black
  static const Color blackSoft = Color(0xFF0A0A0A);       // Very dark but softer than pure black
  static const Color blackMedium = Color(0xFF1A1A1A);     // Dark charcoal (same as textPrimary)
  static const Color blackLight = Color(0xFF2A2A2A);      // Lighter charcoal
  static const Color charcoal = Color(0xFF36454F);        // Charcoal gray
  static const Color slate = Color(0xFF2F2F2F);           // Slate gray

  static const Color border = Color(0xFF2C2C2C);
  static const Color borderMedium = Color(0xFF9F9F9F);
  // static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);

  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFE17055);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF4A90E2);

  // FONT FAMILY
  static const String fontFamily = 'Figtree';
  // static const String fontFamily = 'Montserrat';
  // static const String fontFamily = 'Nunito Sans';

  // FONT WEIGHTS
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight deep = FontWeight.w900;

// TEXT STYLES - HEADINGS (with tighter letter spacing)
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: bold,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -0.8, // Tighter spacing for large headers
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: bold,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.7,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.6,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.5,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.4,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.3,
  );

// TEXT STYLES - BODY (with subtle tighter spacing)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    color: textPrimary,
    height: 1.5,
    letterSpacing: -0.2, // Subtle tightening for body text
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    color: textPrimary,
    height: 1.5,
    letterSpacing: -0.1,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    color: textSecondary,
    height: 1.5,
    letterSpacing: -0.1,
  );

  // TEXT STYLES - SPECIALIZED
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    color: textLight,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    color: textWhite,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    color: textWhite,
    height: 1.2,
  );

  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: medium,
    color: goldPrimary,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: bold,
    color: textWhite,
    height: 1.2,
  );

  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle rating = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: medium,
    color: textPrimary,
    height: 1.3,
  );

  // CARD STYLES
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );

  static BoxDecoration serviceCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // GRADIENT STYLES
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldPrimary, goldDark],
  );

  static LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.black.withOpacity(0.7),
    ],
  );

}
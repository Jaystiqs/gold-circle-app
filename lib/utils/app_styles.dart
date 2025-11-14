import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized style management for Gold Circle app
class AppStyles {
  AppStyles._();

  // PRIMARY BRAND COLORS
  static const Color goldPrimary = Color(0xFFCF9810);
  static const Color goldLight = Color(0xFFF4E8C1);
  static const Color goldDark = Color(0xFFAC7E0E);

  // ACCENT COLORS - Use these for buttons and highlights
  static const Color accentPrimary = Color(0xFF1A1A1A);      // Black - Primary accent
  static const Color accentSecondary = Color(0xFF0D7377);    // Deep Teal - Secondary accent
  static const Color accentTertiary = Color(0xFF2C5F66);     // Darker Teal

  // Alternative accent options (uncomment to use instead):
  // static const Color accentSecondary = Color(0xFF1B4965);   // Navy Blue
  // static const Color accentSecondary = Color(0xFF2D5016);   // Forest Green
  // static const Color accentSecondary = Color(0xFF6B4C9A);   // Rich Purple

  // BACKGROUNDS
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundGrey = Color(0xFFF8F8F8);
  static const Color cardBackground = Colors.white;

  // TEXT COLORS
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;
  static const Color textBlack = Colors.black;

  // BLACK SHADES
  static const Color black = Color(0xFF000000);
  static const Color blackSoft = Color(0xFF0A0A0A);
  static const Color blackMedium = Color(0xFF1A1A1A);
  static const Color blackLight = Color(0xFF2A2A2A);
  static const Color charcoal = Color(0xFF36454F);
  static const Color slate = Color(0xFF2F2F2F);

  // BORDERS
  static const Color border = Color(0xFF2C2C2C);
  static const Color borderMedium = Color(0xFF9F9F9F);
  static const Color borderLight = Color(0xFFF0F0F0);

  // STATUS COLORS
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFE17055);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF4A90E2);

  // // FONT FAMILY
  // static const String fontFamily = 'Figtree';

  // FONT FAMILY - Use Google Fonts
  static final String fontFamily = GoogleFonts.figtree().fontFamily!;

  // FONT WEIGHTS
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight deep = FontWeight.w900;

  // BUTTON STYLES - Pre-configured button themes

  // Primary button (Gold)
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: goldPrimary,
    foregroundColor: textWhite,
    disabledBackgroundColor: textLight.withOpacity(0.5),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 0,
  );

  // Secondary button (Black)
  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: accentPrimary,
    foregroundColor: textWhite,
    disabledBackgroundColor: textLight,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 0,
  );

  // Tertiary button (Teal)
  static ButtonStyle tertiaryButton = ElevatedButton.styleFrom(
    backgroundColor: accentSecondary,
    foregroundColor: textWhite,
    disabledBackgroundColor: textLight,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 0,
  );

  // Outline button
  static ButtonStyle outlineButton = OutlinedButton.styleFrom(
    foregroundColor: accentPrimary,
    side: BorderSide(color: accentPrimary, width: 1.5),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  // TEXT STYLES (keeping your existing ones)
  static final TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: bold,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -0.8,
  );

  static final TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: bold,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.7,
  );

  static final TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.6,
  );

  static final TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.5,
  );

  static final TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.4,
  );

  static final TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
    letterSpacing: -0.3,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    color: textPrimary,
    height: 1.5,
    letterSpacing: -0.2,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    color: textPrimary,
    height: 1.5,
    letterSpacing: -0.1,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    color: textSecondary,
    height: 1.5,
    letterSpacing: -0.1,
  );

  static final TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    color: textLight,
    height: 1.4,
  );

  static final TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    color: textWhite,
    height: 1.2,
  );

  static final TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    color: textWhite,
    height: 1.2,
  );

  static final TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: medium,
    color: goldPrimary,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  static final TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: bold,
    color: textWhite,
    height: 1.2,
  );

  static final TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.3,
  );

  static final TextStyle rating = TextStyle(
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

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentSecondary, accentTertiary],
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Color Palette ---
const Color diuPrimaryGreen = Color(0xFF006A4E); // A deep
const Color diuAccentRed = Color(0xFFF42A41); // A strong
const Color diuLightGreen = Color(0xFF5DB996); // A lighter, more muted green
const Color diuBackgroundColor = Color(
  0xFFFFFBF1,
); // A very light, warm off-white for main backgrounds
const Color diuSurfaceColor = Color(
  0xFFFBF6E9,
); // Same as background for cards, dialogs, etc.

// On-color definitions (for text/icons placed on top of primary, secondary, etc.)
const Color diuOnPrimaryColor = Colors.white; // Text/icons on primary green
const Color diuOnSecondaryColor =
    diuPrimaryGreen; // Text/icons on secondary color (red)
const Color diuOnSurfaceColor =
    Colors.black87; // Dark text/icons on light surface/background
const Color diuOnErrorColor = Colors.white; // Text/icons on error color
const Color diuErrorColor = Colors.red; // Standard error red

// --- Main Theme Data ---
final ThemeData transitTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: diuPrimaryGreen,
    primaryContainer: diuLightGreen,
    secondary: diuAccentRed,
    secondaryContainer: Color(0xFFE3F0AF),
    tertiary: diuLightGreen,
    surface: diuSurfaceColor,
    error: diuErrorColor,
    onPrimary: diuOnPrimaryColor,
    onSecondary: diuOnSecondaryColor,
    onSurface: diuOnSurfaceColor, // Added onBackground for completeness
    onError: diuOnErrorColor,
    outline: diuLightGreen,
    shadow: Colors.black12,
  ),
  scaffoldBackgroundColor: diuBackgroundColor,
  fontFamily: GoogleFonts.montserrat().fontFamily,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: diuOnSurfaceColor,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 45,
      fontWeight: FontWeight.w600,
      color: diuOnSurfaceColor,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      color: diuOnSurfaceColor,
    ),
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: diuPrimaryGreen,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: diuPrimaryGreen,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: diuPrimaryGreen,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: diuOnSurfaceColor,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: diuOnSurfaceColor,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: diuOnSurfaceColor,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: diuOnSurfaceColor,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: diuOnSurfaceColor,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: diuOnSurfaceColor,
      height: 1.3,
    ),
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: diuOnPrimaryColor,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: diuOnSurfaceColor,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: diuOnSurfaceColor,
      letterSpacing: 0.5,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: diuPrimaryGreen,
    foregroundColor: diuOnPrimaryColor,
    elevation: 4.0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(
      color: diuOnPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: diuOnPrimaryColor),
    actionsIconTheme: const IconThemeData(color: diuOnPrimaryColor),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: diuAccentRed,
    foregroundColor: diuOnPrimaryColor,
    shape: CircleBorder(),
    elevation: 6.0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: diuPrimaryGreen,
      foregroundColor: diuOnPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      elevation: 3.0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: diuPrimaryGreen,
      textStyle: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: diuPrimaryGreen,
      side: const BorderSide(color: diuPrimaryGreen, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: diuBackgroundColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: diuPrimaryGreen, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: diuLightGreen, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: diuErrorColor, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: diuErrorColor, width: 2.0),
    ),
    labelStyle: GoogleFonts.montserrat(color: diuPrimaryGreen),
    hintStyle: GoogleFonts.montserrat(
      color: diuOnSurfaceColor.withOpacity(0.6),
    ),
    errorStyle: GoogleFonts.montserrat(color: diuErrorColor, fontSize: 12),
    prefixIconColor: diuPrimaryGreen,
    suffixIconColor: diuPrimaryGreen,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: diuPrimaryGreen,
    selectedItemColor: diuOnPrimaryColor,
    unselectedItemColor: diuLightGreen,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
    elevation: 8.0,
  ),
  iconTheme: const IconThemeData(color: diuPrimaryGreen, size: 24.0),
  dividerTheme: const DividerThemeData(
    color: diuLightGreen,
    thickness: 1.0,
    indent: 16.0,
    endIndent: 16.0,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: diuPrimaryGreen,
    linearTrackColor: diuLightGreen,
    circularTrackColor: diuLightGreen,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: diuLightGreen.withOpacity(0.3),
    labelStyle: GoogleFonts.montserrat(color: diuOnSurfaceColor),
    deleteIconColor: diuPrimaryGreen,
    selectedColor: diuPrimaryGreen,
    secondaryLabelStyle: GoogleFonts.montserrat(color: diuOnPrimaryColor),
    secondarySelectedColor: diuPrimaryGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    iconColor: diuPrimaryGreen,
    collapsedIconColor: diuPrimaryGreen,
    textColor: diuPrimaryGreen,
    collapsedTextColor: diuOnSurfaceColor,
    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    childrenPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: diuPrimaryGreen.withOpacity(0.9),
      borderRadius: BorderRadius.circular(4.0),
    ),
    textStyle: GoogleFonts.montserrat(color: diuOnPrimaryColor),
    padding: const EdgeInsets.all(8.0),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: diuPrimaryGreen,
    inactiveTrackColor: diuLightGreen,
    thumbColor: diuPrimaryGreen,
    overlayColor: diuPrimaryGreen.withOpacity(0.2),
    valueIndicatorColor: diuPrimaryGreen,
    valueIndicatorTextStyle: GoogleFonts.montserrat(color: diuOnPrimaryColor),
  ),
);

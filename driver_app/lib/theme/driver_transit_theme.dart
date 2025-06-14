import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Color Palette for Driver App ---
const Color driverPrimaryBlue = Color(0xFF005691); // A deep blue
const Color driverAccentOrange = Color(0xFFE07A5F); // A strong, vibrant orange
const Color driverLightBlue = Color(0xFF5D9ECC); // A lighter, more muted blue
const Color driverBackgroundColor = Color(0xFFF7F9FC); // A very light, cool off-white
const Color driverSurfaceColor = Color(0xFFF0F4F8); // Slightly darker for cards, dialogs, etc.

// On-color definitions (for text/icons placed on top of primary, secondary, etc.)
const Color driverOnPrimaryColor = Colors.white; // Text/icons on primary blue
const Color driverOnSecondaryColor = driverPrimaryBlue; // Text/icons on secondary color (orange)
const Color driverOnSurfaceColor = Colors.black87; // Dark text/icons on light surface/background
const Color driverOnErrorColor = Colors.white; // Text/icons on error color
const Color driverErrorColor = Colors.red; // Standard error red

// --- Main Theme Data for Driver App ---
final ThemeData driverTransitTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: driverPrimaryBlue,
    primaryContainer: driverLightBlue,
    secondary: driverAccentOrange,
    secondaryContainer: Color(0xFFFFCCB2), // Lighter orange
    tertiary: driverLightBlue,
    surface: driverSurfaceColor,
    error: driverErrorColor,
    onPrimary: driverOnPrimaryColor,
    onSecondary: driverOnSecondaryColor,
    onSurface: driverOnSurfaceColor,
    onError: driverOnErrorColor,
    outline: driverLightBlue,
    shadow: Colors.black12,
  ),
  scaffoldBackgroundColor: driverBackgroundColor,
  fontFamily: GoogleFonts.montserrat().fontFamily,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: driverOnSurfaceColor,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 45,
      fontWeight: FontWeight.w600,
      color: driverOnSurfaceColor,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      color: driverOnSurfaceColor,
    ),
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: driverPrimaryBlue,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: driverPrimaryBlue,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: driverPrimaryBlue,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: driverOnSurfaceColor,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: driverOnSurfaceColor,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: driverOnSurfaceColor,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: driverOnSurfaceColor,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: driverOnSurfaceColor,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: driverOnSurfaceColor,
      height: 1.3,
    ),
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: driverOnPrimaryColor,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: driverOnSurfaceColor,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: driverOnSurfaceColor,
      letterSpacing: 0.5,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: driverPrimaryBlue,
    foregroundColor: driverOnPrimaryColor,
    elevation: 4.0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(
      color: driverOnPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: driverOnPrimaryColor),
    actionsIconTheme: const IconThemeData(color: driverOnPrimaryColor),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: driverAccentOrange,
    foregroundColor: driverOnPrimaryColor,
    shape: CircleBorder(),
    elevation: 6.0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: driverPrimaryBlue,
      foregroundColor: driverOnPrimaryColor,
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
      foregroundColor: driverPrimaryBlue,
      textStyle: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: driverPrimaryBlue,
      side: const BorderSide(color: driverPrimaryBlue, width: 1.5),
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
    fillColor: driverBackgroundColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: driverPrimaryBlue, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: driverLightBlue, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: driverErrorColor, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: driverErrorColor, width: 2.0),
    ),
    labelStyle: GoogleFonts.montserrat(color: driverPrimaryBlue),
    hintStyle: GoogleFonts.montserrat(
      color: driverOnSurfaceColor.withOpacity(0.6),
    ),
    errorStyle: GoogleFonts.montserrat(color: driverErrorColor, fontSize: 12),
    prefixIconColor: driverPrimaryBlue,
    suffixIconColor: driverPrimaryBlue,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: driverPrimaryBlue,
    selectedItemColor: driverOnPrimaryColor,
    unselectedItemColor: driverLightBlue,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    type: BottomNavigationBarType.fixed,
    elevation: 8.0,
  ),
  iconTheme: const IconThemeData(color: driverPrimaryBlue, size: 24.0),
  dividerTheme: const DividerThemeData(
    color: driverLightBlue,
    thickness: 1.0,
    indent: 16.0,
    endIndent: 16.0,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: driverPrimaryBlue,
    linearTrackColor: driverLightBlue,
    circularTrackColor: driverLightBlue,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: driverLightBlue.withOpacity(0.3),
    labelStyle: GoogleFonts.montserrat(color: driverOnSurfaceColor),
    deleteIconColor: driverPrimaryBlue,
    selectedColor: driverPrimaryBlue,
    secondaryLabelStyle: GoogleFonts.montserrat(color: driverOnPrimaryColor),
    secondarySelectedColor: driverPrimaryBlue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    iconColor: driverPrimaryBlue,
    collapsedIconColor: driverPrimaryBlue,
    textColor: driverPrimaryBlue,
    collapsedTextColor: driverOnSurfaceColor,
    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    childrenPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: driverPrimaryBlue.withOpacity(0.9),
      borderRadius: BorderRadius.circular(4.0),
    ),
    textStyle: GoogleFonts.montserrat(color: driverOnPrimaryColor),
    padding: const EdgeInsets.all(8.0),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: driverPrimaryBlue,
    inactiveTrackColor: driverLightBlue,
    thumbColor: driverPrimaryBlue,
    overlayColor: driverPrimaryBlue.withOpacity(0.2),
    valueIndicatorColor: driverPrimaryBlue,
    valueIndicatorTextStyle: GoogleFonts.montserrat(color: driverOnPrimaryColor),
  ),
);

// --- Thanks Google Gemini for give this theme data ---
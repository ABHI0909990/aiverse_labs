import 'package:flutter/material.dart';
import 'color.dart';
import 'font_family.dart';

class AppThemes {
  static BoxDecoration _getGradientDecoration({
    required bool isDark,
    required List<Color> lightColors,
    required List<Color> darkColors,
    double borderRadius = 16.0,
    double opacity = 0.9,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark ? darkColors : lightColors,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.accentColor1,
      background: AppColors.backgroundColor,
      surface: AppColors.white,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onBackground: AppColors.primaryTextColor,
      onSurface: AppColors.primaryTextColor,
      error: AppColors.errorColor,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primaryTextColor),
      titleTextStyle: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2SemiBold,
        fontSize: 18,
      ),
      toolbarHeight: 70,
      centerTitle: false,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.primaryColor.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.buttonTextColor,
        elevation: 3,
        shadowColor: AppColors.primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.linkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(
        color: AppColors.secondaryTextColor.withOpacity(0.7),
        fontFamily: AppFonts.family2Regular,
      ),
    ),
    fontFamily: AppFonts.family2Regular,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Bold,
      ),
      displaySmall: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Bold,
      ),
      headlineLarge: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2SemiBold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2SemiBold,
      ),
      headlineSmall: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2SemiBold,
      ),
      titleLarge: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2SemiBold,
      ),
      titleMedium: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Medium,
      ),
      titleSmall: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Medium,
      ),
      bodyLarge: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Regular,
      ),
      bodyMedium: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Regular,
      ),
      bodySmall: TextStyle(
        color: AppColors.secondaryTextColor,
        fontFamily: AppFonts.family2Regular,
      ),
      labelLarge: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Medium,
      ),
      labelMedium: TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Medium,
      ),
      labelSmall: TextStyle(
        color: AppColors.secondaryTextColor,
        fontFamily: AppFonts.family2Regular,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.iconColor,
      size: 24,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontFamily: AppFonts.family2Medium,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: AppFonts.family2Regular,
        fontSize: 12,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGrey,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightGrey,
      disabledColor: AppColors.lightGrey.withOpacity(0.5),
      selectedColor: AppColors.primaryColor.withOpacity(0.2),
      secondarySelectedColor: AppColors.secondaryColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: const TextStyle(
        color: AppColors.primaryTextColor,
        fontFamily: AppFonts.family2Regular,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Medium,
      ),
      brightness: Brightness.light,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryTextColor,
      contentTextStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Regular,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.accentColor1,
      background: AppColors.darkBackgroundColor,
      surface: const Color(0xFF2C2C2C),
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onBackground: AppColors.white,
      onSurface: AppColors.white,
      error: AppColors.errorColor,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2C2C2C),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2SemiBold,
        fontSize: 18,
      ),
      toolbarHeight: 70,
      centerTitle: false,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2C2C2C),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.4),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.buttonTextColor,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.linkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3C3C3C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(
        color: AppColors.grey.withOpacity(0.7),
        fontFamily: AppFonts.family2Regular,
      ),
    ),
    fontFamily: AppFonts.family2Regular,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Bold,
      ),
      displaySmall: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Bold,
      ),
      headlineLarge: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2SemiBold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2SemiBold,
      ),
      headlineSmall: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2SemiBold,
      ),
      titleLarge: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2SemiBold,
      ),
      titleMedium: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Medium,
      ),
      titleSmall: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Medium,
      ),
      bodyLarge: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Regular,
      ),
      bodyMedium: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Regular,
      ),
      bodySmall: TextStyle(
        color: AppColors.grey,
        fontFamily: AppFonts.family2Regular,
      ),
      labelLarge: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Medium,
      ),
      labelMedium: TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Medium,
      ),
      labelSmall: TextStyle(
        color: AppColors.grey,
        fontFamily: AppFonts.family2Regular,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.white,
      size: 24,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontFamily: AppFonts.family2Medium,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: AppFonts.family2Regular,
        fontSize: 12,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3C3C3C),
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF3C3C3C),
      disabledColor: const Color(0xFF3C3C3C).withOpacity(0.5),
      selectedColor: AppColors.primaryColor.withOpacity(0.3),
      secondarySelectedColor: AppColors.secondaryColor.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Regular,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Medium,
      ),
      brightness: Brightness.dark,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF3C3C3C),
      contentTextStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: AppFonts.family2Regular,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

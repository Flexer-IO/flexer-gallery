import 'package:flutter/material.dart';
import 'size_config_two.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
    hintColor: kAccentLightColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      secondary: kSecondaryLightColor,
    ),
    // backgroundColor removed – use scaffoldBackgroundColor or colorScheme.background instead
    iconTheme: const IconThemeData(color: kBodyTextColorLight),
    // actionIconTheme: IconThemeData(color: kAccentIconLightColor),
    primaryIconTheme: const IconThemeData(color: kPrimaryIconLightColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyLarge: const TextStyle(color: kBodyTextColorLight),
      bodyMedium: const TextStyle(color: kBodyTextColorLight),
      headlineLarge: TextStyle(
        color: kTitleTextLightColor,
        fontSize: SizeConfigTwo.blocHeight * 5,
      ),
      headlineMedium: TextStyle(
        color: kTitleTextLightColor,
        fontSize: SizeConfigTwo.blocHeight * 12,
      ),
    ),
  );
}

ThemeData dartThemeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
    hintColor: kAccentDarkColor,
    scaffoldBackgroundColor: const Color(0xFF0D0C0E),
    colorScheme: const ColorScheme.light(
      secondary: kSecondaryDarkColor,
      surface: kSurfaceDarkColor,
    ),
    // backgroundColor removed – use scaffoldBackgroundColor or colorScheme.background instead
    iconTheme: const IconThemeData(color: kBodyTextColorDark),
    // accentIconTheme: IconThemeData(color: kAccentIconDarkColor),
    primaryIconTheme: const IconThemeData(color: kPrimaryIconDarkColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyLarge: const TextStyle(color: kBodyTextColorDark),
      bodyMedium: const TextStyle(color: kBodyTextColorDark),
      headlineLarge: const TextStyle(color: kTitleTextDarkColor),
      headlineMedium: const TextStyle(color: kTitleTextDarkColor),
    ),
  );
}

AppBarTheme appBarTheme = const AppBarTheme(
  backgroundColor: Colors.transparent,
  elevation: 0,
);
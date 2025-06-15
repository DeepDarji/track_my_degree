import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: kPrimaryBlue,
  scaffoldBackgroundColor: Colors.white,
  cardTheme: const CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(kCardBorderRadius)),
    ),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black87,
  ),
  iconTheme: const IconThemeData(color: kPrimaryBlue),
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryBlue,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kPrimaryBlue,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kAccentGreen,
    error: Colors.redAccent,
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: kPrimaryBlue,
  scaffoldBackgroundColor: Colors.grey[900],
  cardTheme: CardTheme(
    elevation: 2,
    color: Colors.grey[800],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(kCardBorderRadius)),
    ),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.white70,
    displayColor: Colors.white70,
  ),
  iconTheme: const IconThemeData(color: kAccentGreen),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[800],
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kAccentGreen,
    foregroundColor: Colors.black87,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kAccentGreen,
    error: Colors.redAccent,
    brightness: Brightness.dark,
  ),
);

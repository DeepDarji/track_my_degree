import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF2196F3), // Blue for primary actions
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2196F3),
    secondary: Color(0xFF4CAF50), // Green for accents
    surface: Color(0xFFF5F7FA), // Light grey background
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.light().textTheme.copyWith(
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF2196F3),
    unselectedItemColor: Colors.black54,
    showUnselectedLabels: true,
  ),
);

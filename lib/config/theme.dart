import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama
  static const Color primaryColor = Color(0xFF5E3D94); // ungu
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color greyColor = Color(0xFFBDBDBD);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    
    // [PENTING] Set Font Family Utama di sini
    // Nama 'Poppins' harus sama persis dengan yang ada di pubspec.yaml
    fontFamily: 'Poppins', 

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    // Konfigurasi Teks Manual
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, color: textColor),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ).apply(
      // apply() memastikan font ini "menempel" ke semua jenis teks default
      fontFamily: 'Poppins', 
      bodyColor: textColor,
      displayColor: textColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: greyColor),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        // Pastikan teks tombol berwarna putih biar kontras
        foregroundColor: Colors.white, 
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
  );
}
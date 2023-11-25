import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  colorScheme: const ColorScheme(
    primary: Color(0xFF00C2F1),
    // primary text color
    secondary: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    error: Color(0xFFF54018),
    onError: Colors.black,
    onBackground: Colors.white,
    background: Color(0xFFEAEFF2),
    brightness: Brightness.light,
    tertiary: Colors.grey,
    onTertiary: Colors.green,
    surface: Color(0xFFE0E1E5),
    onSurface: Colors.black,
  ),
);

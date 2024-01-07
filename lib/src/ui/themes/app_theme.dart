import 'package:flutter/material.dart';

extension AppGapSize on ThemeData {
  static double gapSize = 8;
  SizedBox get gs => SizedBox(height: gapSize, width: gapSize);
  SizedBox get gm => SizedBox(height: gapSize * 2, width: gapSize * 2);
  SizedBox get gl => SizedBox(height: gapSize * 3, width: gapSize * 3);
}

class AppTheme {
  ThemeData get theme => ThemeData(useMaterial3: true).copyWith(
        inputDecorationTheme: inputDecorationTheme,
        outlinedButtonTheme: outlinedButtonTheme,
        cardTheme: cardTheme,
      );

  get inputDecorationTheme => const InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(),
      );

  get outlinedButtonTheme => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      );

  get cardTheme => CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
}

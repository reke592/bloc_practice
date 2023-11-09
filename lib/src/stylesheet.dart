import 'package:flutter/material.dart';

abstract class Stylesheet {
  static const buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static const containerShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(24)),
  );

  static const black1 = Colors.black87;
  static const black2 = Colors.black;

  static const grey1 = Color.fromRGBO(30, 30, 30, 1);
  static const grey2 = Color.fromRGBO(30, 30, 30, 0.5);

  static final green1 = Colors.green.shade600;

  static final blue1 = Colors.blue.shade600;

  static const white1 = Colors.white70;
  static const white2 = Colors.white;
  static final white3 = Colors.amber.shade50;

  static final mainTheme = darkTheme;

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: black1,
      onPrimary: white2,
      secondary: Colors.blueGrey.shade800,
      onSecondary: white2,
      error: Colors.transparent,
      onError: Colors.amber.shade900,
      background: grey1,
      onBackground: white1,
      surface: grey1,
      onSurface: white1,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: white1,
      color: Colors.transparent,
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: white1,
        shape: buttonShape,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        shape: buttonShape.copyWith(
          side: const BorderSide(color: white1, width: 1),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: white1,
        shape: buttonShape,
      ),
    ),
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(8),
      shape: containerShape,
    ),
    dialogTheme: const DialogTheme(
      shape: containerShape,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: white2),
      ),
      isDense: true,
      alignLabelWithHint: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: white3),
      ),
      labelStyle: const TextStyle(color: white1),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.transparent,
      checkmarkColor: green1,
      side: BorderSide(color: white1.withOpacity(0.5), width: 0.5),
      labelStyle: const TextStyle(color: white1),
      secondaryLabelStyle: const TextStyle(color: black1),
      secondarySelectedColor: black1,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: white1,
      circularTrackColor: green1,
      linearTrackColor: green1,
      linearMinHeight: 1.25,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return green1;
          }
          return white1;
        },
      ),
    ),
    listTileTheme: ListTileThemeData(
      minVerticalPadding: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) => grey1),
      trackVisibility: MaterialStateProperty.resolveWith((states) => false),
      thumbVisibility: MaterialStateProperty.resolveWith((states) => true),
      thickness: MaterialStateProperty.resolveWith((states) => 2),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: white1,
      selectionColor: blue1,
      selectionHandleColor: blue1,
    ),
  );
}

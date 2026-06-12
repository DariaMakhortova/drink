import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const frostySke = Color(0xFFCBDFEA);
  const mochaEarth = Color(0xFF4B3935);

  const surface = Colors.white;
  const outline = Color(0xFFD4DDE3);
  const textPrimary = Color(0xFF2F2623);
  const textMuted = Color(0xFF73655F);

  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: mochaEarth,
        brightness: Brightness.light,
      ).copyWith(
        primary: mochaEarth,
        secondary: frostySke,
        surface: surface,
        background: frostySke,
        onPrimary: Colors.white,
        onSecondary: mochaEarth,
        onSurface: textPrimary,
        outline: outline,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: frostySke,
    splashFactory: InkRipple.splashFactory,

    appBarTheme: const AppBarTheme(
      backgroundColor: frostySke,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: textPrimary,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w900),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w900,
      ),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textMuted),
      bodySmall: TextStyle(color: textMuted),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: outline),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: mochaEarth.withOpacity(0.12),
      side: const BorderSide(color: outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      labelStyle: const TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: mochaEarth, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
      labelStyle: const TextStyle(
        color: textMuted,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: const TextStyle(color: Color(0xFF9A8F8A)),
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 60,
      backgroundColor: Colors.white,
      elevation: 0,
      indicatorColor: mochaEarth.withOpacity(0.12),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: mochaEarth,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: mochaEarth,
        side: const BorderSide(color: outline),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: mochaEarth,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? mochaEarth : null,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? mochaEarth.withOpacity(0.30)
            : outline,
      ),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: mochaEarth,
      inactiveTrackColor: outline,
      thumbColor: mochaEarth,
      overlayColor: mochaEarth.withOpacity(0.12),
    ),
  );
}

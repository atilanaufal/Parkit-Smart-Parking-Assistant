// Final AppTheme + ThemeExtension for Parkit

import 'package:flutter/material.dart';

class ParkitExtras extends ThemeExtension<ParkitExtras> {
  final Color shadow;
  final Color brandBlueTransparent;
  final Color warning;
  final Color warningTransparent;

  const ParkitExtras({
    required this.shadow,
    required this.brandBlueTransparent,
    required this.warning,
    required this.warningTransparent,
  });

  @override
  ParkitExtras copyWith({
    Color? shadow,
    Color? brandBlueTransparent,
    Color? warning,
    Color? warningTransparent,
  }) {
    return ParkitExtras(
      shadow: shadow ?? this.shadow,
      brandBlueTransparent: brandBlueTransparent ?? this.brandBlueTransparent,
      warning: warning ?? this.warning,
      warningTransparent: warningTransparent ?? this.warningTransparent,
    );
  }

  @override
  ParkitExtras lerp(ThemeExtension<ParkitExtras>? other, double t) {
    if (other is! ParkitExtras) return this;
    return ParkitExtras(
      shadow: Color.lerp(shadow, other.shadow, t)!,
      brandBlueTransparent: Color.lerp(
        brandBlueTransparent,
        other.brandBlueTransparent,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningTransparent: Color.lerp(
        warningTransparent,
        other.warningTransparent,
        t,
      )!,
    );
  }
}

class AppTheme {
  static const Color _lightPrimary = Color(0xFF0F4B8A);
  static const Color _lightSurface = Color(0xFFF5F7FF);
  static const Color _lightSurfaceContainer = Colors.white;
  static const Color _lightSecondary = Color(0xFF00A12E);
  static const Color _lightError = Color(0xFFEE302E);
  static const Color _lightText = Color(0xFF1A1A1A);

  static const Color _darkPrimary = Color(0xFF171F39);
  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkSurfaceContainer = Color(0xFF1E1E2E);
  static const Color _darkSecondary = Color(0xFF00A12E);
  static const Color _darkError = Color(0xFFEE302E);
  static const Color _darkText = Color(0xFFFFFFFF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: Colors.white,

      secondary: _lightSecondary,
      onSecondary: Colors.white,

      error: _lightError,
      onError: Colors.white,

      surface: _lightSurface,
      onSurface: _lightText,

      surfaceContainerHighest: _lightSurfaceContainer,
      surfaceContainerHigh: _lightSurfaceContainer,
      surfaceContainer: _lightSurfaceContainer,
      surfaceContainerLow: _lightSurfaceContainer,
      surfaceContainerLowest: _lightSurfaceContainer,
    ),

    extensions: const [
      ParkitExtras(
        shadow: Color.fromRGBO(0, 0, 0, 0.06),
        brandBlueTransparent: Color(0x334E71FF),
        warning: Color(0xFFFF9800),
        warningTransparent: Color(0x33FF9800),
      ),
    ],

    scaffoldBackgroundColor: _lightSurface,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: Colors.white,

      secondary: _darkSecondary,
      onSecondary: Colors.white,

      error: _darkError,
      onError: Colors.white,

      surface: _darkSurface,
      onSurface: _darkText,

      surfaceContainerHighest: _darkSurfaceContainer,
      surfaceContainerHigh: _darkSurfaceContainer,
      surfaceContainer: _darkSurfaceContainer,
      surfaceContainerLow: _darkSurfaceContainer,
      surfaceContainerLowest: _darkSurfaceContainer,
    ),

    extensions: const [
      ParkitExtras(
        shadow: Color.fromRGBO(0, 0, 0, 0.06),
        brandBlueTransparent: Color(0x334E71FF),
        warning: Color(0xFFFF9800),
        warningTransparent: Color(0x33FF9800),
      ),
    ],

    scaffoldBackgroundColor: _darkSurface,
  );
}

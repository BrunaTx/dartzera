import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

// =============================================================================
// TEXT STYLE EXTENSIONS
// =============================================================================

extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

// =============================================================================
// COLORS (COPA THEME — CENTRALIZADO)
// =============================================================================

class LightModeColors {
  // 🟢 VERDE (primary)
  static const lightPrimary = Color.fromARGB(255, 3, 116, 50);
  static const lightOnPrimary = Color(0xFFE8FFF1);

  static const lightPrimaryContainer = Color.fromARGB(255, 211, 53, 118);
  static const lightOnPrimaryContainer = Color(0xFFE8FFF1);

  // 🟡 AMARELO (secondary)
  static const lightSecondary = Color.fromARGB(255, 211, 53, 118);
  static const lightOnSecondary = Color.fromARGB(255, 255, 255, 255);

  // 🔵 AZUL (tertiary)
  static const lightTertiary = Color.fromARGB(255, 255, 238, 0);
  static const lightOnTertiary = Color.fromARGB(255, 241, 233, 119);

  // ❌ ERROR
  static const lightError = Color(0xFFFF5252);
  static const lightOnError = Colors.white;
  static const lightErrorContainer =Color.fromARGB(255, 173, 5, 106);
  static const lightOnErrorContainer = Color(0xFFFFDADA);

  // 🌸 FUNDO ROSA ESCURO (copa vibe)
  static const lightBackground = Color.fromARGB(255, 8, 67, 143);
  static const lightSurface = Color.fromARGB(255, 8, 67, 143);
  static const lightSurfaceVariant = Color.fromARGB(255, 8, 67, 143);

  static const lightOnSurface = Color(0xFFFFF1F7);
  static const lightOnSurfaceVariant = Color(0xFFFFD3E3);

  static const lightOutline = Color(0x66FFFFFF);
  static const lightShadow = Colors.black;

  static const lightInversePrimary = Color.fromARGB(255, 3, 116, 50);
}

class DarkModeColors {
  static const darkPrimary = Color.fromARGB(255, 3, 116, 50);
  static const darkOnPrimary = Color(0xFFE8FFF1);

  static const darkPrimaryContainer = Color(0xFF007E33);
  static const darkOnPrimaryContainer = Color(0xFFE8FFF1);

  static const darkSecondary = Color.fromARGB(255, 240, 228, 102);
  static const darkOnSecondary = Color(0xFF2B2200);

  static const darkTertiary = Color.fromARGB(255, 5, 62, 161);
  static const darkOnTertiary = Colors.white;

  static const darkError = Color(0xFFFF5252);
  static const darkOnError = Color(0xFF690005);

  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDADA);

  static const darkSurface = Color(0xFF1A0A12);
  static const darkOnSurface = Color(0xFFFFF1F7);
  static const darkSurfaceVariant = Color.fromARGB(255, 173, 5, 106);

  static const darkOnSurfaceVariant = Color(0xFFFFD3E3);

  static const darkOutline = Color(0x66FFFFFF);
  static const darkShadow = Colors.black;

  static const darkInversePrimary = Color.fromARGB(255, 3, 116, 50);
}

// =============================================================================
// FONT SIZES
// =============================================================================

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

// =============================================================================
// THEMES
// =============================================================================

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    onSurfaceVariant: LightModeColors.lightOnSurfaceVariant,
    outline: LightModeColors.lightOutline,
    shadow: LightModeColors.lightShadow,
    inversePrimary: LightModeColors.lightInversePrimary,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightBackground,

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: LightModeColors.lightPrimary,
      foregroundColor: LightModeColors.lightOnPrimary,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LightModeColors.lightPrimary,
      foregroundColor: LightModeColors.lightOnPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: LightModeColors.lightOutline, width: 1),
    ),
  ),

  textTheme: _buildTextTheme(Brightness.light),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    onSurfaceVariant: DarkModeColors.darkOnSurfaceVariant,
    outline: DarkModeColors.darkOutline,
    shadow: DarkModeColors.darkShadow,
    inversePrimary: DarkModeColors.darkInversePrimary,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkModeColors.darkSurface,
  textTheme: _buildTextTheme(Brightness.dark),
);

// =============================================================================

TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: FontSizes.displayLarge),
    displayMedium: GoogleFonts.inter(fontSize: FontSizes.displayMedium),
    displaySmall: GoogleFonts.inter(fontSize: FontSizes.displaySmall),
    headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.inter(),
    bodyMedium: GoogleFonts.inter(),
    bodySmall: GoogleFonts.inter(),
  );
}

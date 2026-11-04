import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniChatTheme {
  /// The theme of the UniChat
  static ThemeData get theme {
    return ThemeData(
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      primaryTextTheme: _arabicTextTheme(),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  /// Same as google_fonts' ibmPlexSansArabicTextTheme, built with Flutter's TextTheme
  /// (google_fonts 9 returns material_ui types that ThemeData doesn't accept).
  static TextTheme _arabicTextTheme() {
    final base = ThemeData.light().textTheme;
    TextStyle font(TextStyle? style) =>
        GoogleFonts.ibmPlexSansArabic(textStyle: style);
    return base.copyWith(
      displayLarge: font(base.displayLarge),
      displayMedium: font(base.displayMedium),
      displaySmall: font(base.displaySmall),
      headlineLarge: font(base.headlineLarge),
      headlineMedium: font(base.headlineMedium),
      headlineSmall: font(base.headlineSmall),
      titleLarge: font(base.titleLarge),
      titleMedium: font(base.titleMedium),
      titleSmall: font(base.titleSmall),
      bodyLarge: font(base.bodyLarge),
      bodyMedium: font(base.bodyMedium),
      bodySmall: font(base.bodySmall),
      labelLarge: font(base.labelLarge),
      labelMedium: font(base.labelMedium),
      labelSmall: font(base.labelSmall),
    );
  }
}

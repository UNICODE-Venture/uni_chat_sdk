import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniChatTheme {
  /// The theme of the UniChat
  static ThemeData get theme {
    return ThemeData(
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      primaryTextTheme: GoogleFonts.ibmPlexSansArabicTextTheme(),
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
}

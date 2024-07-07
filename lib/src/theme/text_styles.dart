import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import 'colors.dart';

final _colors = ColorsPalletes.instance;

class TextStyles {
  TextStyles._();
  static TextStyles? _instance;

  /// Get the instance of the [TextStyles]
  static TextStyles get instance => _instance ??= TextStyles._();

  /// Text style
  TextStyle get text14Medium => GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.rSp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get text14MediumWhite => GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.rSp,
        fontWeight: FontWeight.w500,
        color: _colors.white,
      );

  TextStyle get text20MediumWhite => GoogleFonts.ibmPlexSansArabic(
        fontSize: 20.rSp,
        fontWeight: FontWeight.w500,
        color: _colors.white,
      );

  TextStyle get text16Bold => GoogleFonts.ibmPlexSansArabic(
        fontSize: 16.rSp,
        fontWeight: FontWeight.w700,
      );

  TextStyle get text15LightBoldWhite => GoogleFonts.ibmPlexSansArabic(
        fontSize: 15.rSp,
        fontWeight: FontWeight.w600,
        color: _colors.white,
      );

  TextStyle get dateTextStyle => GoogleFonts.ibmPlexSansArabic(
        fontSize: 11.rSp,
        color: _colors.lightDark06,
        fontWeight: FontWeight.w500,
      );
}

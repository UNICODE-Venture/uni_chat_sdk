import 'package:flutter/material.dart';

class UniLocalizationsData {
  /// [supportLocale] is the list of supported locales
  static List<Locale> supportLocale = const [
    Locale("ar", "SA"),
    Locale("en", "US"),
  ];

  /// [currentLocale] is the current locale of the app
  static Locale currentLocale = supportLocale.first;
}

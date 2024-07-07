import 'package:flutter/material.dart';

class ColorsPalletes {
  ColorsPalletes._();
  static ColorsPalletes? _instance;

  /// Get the instance of the [ColorsPalletes]
  static ColorsPalletes get instance => _instance ??= ColorsPalletes._();

  /// Primary color
  Color primaryColor = const Color(0xFF17BF96);

  /// Grey My bubble bg color
  Color myBubbleBgColor = const Color(0xFFF7F7F8);

  /// Grey Other bubble bg color
  Color get peerBubbleBgColor => primaryColor;

  // Grey colors
  Color grey600 = const Color(0xFF57576B);
  Color grey500 = const Color(0xFF6E6E87);
  Color grey400 = const Color(0xFF89899F);
  Color grey20 = const Color(0xFFF3F6FF);
  Color lightDark06 = const Color(0xFF80808d);

  Color white = Colors.white;
  Color red = Colors.red;
  Color black = Colors.black;

  // Chat colors
  Color deepOrange = const Color(0xFFF68F55);
  Color blueSky = const Color(0xFF06C1FF);
  Color greenLight = const Color(0xFF17BF96);
  Color pink = const Color(0xFFFF7D7D);
  Color green = Colors.green;
}

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class UniUtils {
  UniUtils._();
  static UniUtils? _instance;

  /// Singleton instance of [UniUtils]
  static UniUtils get instance => _instance ??= UniUtils._();

  /// Get the unique identifier
  String get getUID => _uuid.v4();

  /// [hideKeyboard] Hide the keyboard
  Future hideKeyboard() async {
    // Hide the keyboard
    return FocusManager.instance.primaryFocus?.unfocus();
  }
}

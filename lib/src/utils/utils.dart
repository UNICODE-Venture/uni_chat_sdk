import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class UniUtils {
  UniUtils._();
  static UniUtils? _instance;

  /// Singleton instance of [UniUtils]
  static UniUtils get instance => _instance ??= UniUtils._();

  /// Get the unique identifier
  String get getUID => _uuid.v4();
}

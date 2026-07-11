import 'sealed_media.dart';

/// Public entry point for priming the chat SDK's media tokens.
///
/// The host app's `SealedMedia` and this SDK's internal `SealedMedia` keep
/// separate caches, so the host must prime this one too. Call from the splash
/// (before showing chat/media screens) so the first chat image doesn't race to
/// a 401 under App Check enforcement.
class UniChatMedia {
  UniChatMedia._();

  /// Fetch + cache the App Check token (always) and the ID token (when signed
  /// in). Best-effort with an internal timeout — never hangs startup.
  static Future<void> prime() => SealedMedia.prime();
}

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Workstream B — media sealing for the chat SDK.
///
/// Reads go to the tokenless `?alt=media` endpoint. Under App Check enforcement
/// it needs `X-Firebase-AppCheck` (always) + `Authorization: Firebase <idToken>`
/// (when signed in). Self-initializes lazily so host apps need no wiring.
class SealedMedia {
  SealedMedia._();

  static const _storageHost = 'firebasestorage.googleapis.com';
  static String? _idToken;
  static String? _appCheckToken;
  static bool _started = false;

  static void _ensureListening() {
    if (_started) return;
    _started = true;
    FirebaseAuth.instance.idTokenChanges().listen((user) async {
      _idToken = user == null ? null : await user.getIdToken();
    });
    FirebaseAppCheck.instance.onTokenChange.listen((t) => _appCheckToken = t);
    FirebaseAuth.instance.currentUser?.getIdToken().then((t) => _idToken = t);
    FirebaseAppCheck.instance
        .getToken()
        .then((t) => _appCheckToken = t)
        .catchError((_) => null);
  }

  /// Strip the download token -> tokenless `?alt=media`. Non-storage URLs
  /// returned unchanged.
  static String seal(String url) {
    _ensureListening();
    if (url.isEmpty || !url.contains(_storageHost)) return url;
    final u = Uri.parse(url);
    return u.replace(queryParameters: {'alt': 'media'}).toString();
  }

  static Uri sealUri(String url) => Uri.parse(seal(url));

  /// App Check (always, for enforcement) + auth (when signed in) headers.
  static Map<String, String> get headers {
    _ensureListening();
    final h = <String, String>{};
    if (_appCheckToken != null) h['X-Firebase-AppCheck'] = _appCheckToken!;
    if (_idToken != null) h['Authorization'] = 'Firebase $_idToken';
    return h;
  }

  static String buildUrl(Reference ref) =>
      'https://$_storageHost/v0/b/${ref.bucket}/o/'
      '${Uri.encodeComponent(ref.fullPath)}?alt=media';
}

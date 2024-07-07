import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final _cacheManager = DefaultCacheManager();

class CacheServices {
  CacheServices._();
  static CacheServices? _instance;

  /// [instance] is the singleton instance of the [CacheServices]
  static CacheServices get instance => _instance ??= CacheServices._();

  /// [getFile] is a method to get a single file from the cache
  Future<File> getFile(String url) async {
    return _cacheManager.getSingleFile(url);
  }
}

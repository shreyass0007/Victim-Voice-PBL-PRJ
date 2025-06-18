import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  static const String _cachePrefix = 'cache_';
  static const Duration _defaultCacheDuration = Duration(hours: 24);

  // In-memory cache for faster access
  static final Map<String, _CacheItem> _memoryCache = {};

  static Future<void> saveData(
    String key,
    dynamic data, {
    Duration? duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = _CacheItem(
      data: data,
      timestamp: DateTime.now(),
      duration: duration ?? _defaultCacheDuration,
    );

    // Save to memory cache
    _memoryCache[key] = cacheData;

    // Save to persistent storage
    await prefs.setString(
      _cachePrefix + key,
      jsonEncode({
        'data': data,
        'timestamp': cacheData.timestamp.toIso8601String(),
        'duration': cacheData.duration.inSeconds,
      }),
    );
  }

  static Future<T?> getData<T>(String key) async {
    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      final cacheItem = _memoryCache[key]!;
      if (!cacheItem.isExpired) {
        return cacheItem.data as T?;
      }
      _memoryCache.remove(key);
    }

    // Check persistent storage
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cachePrefix + key);
    
    if (cachedData != null) {
      try {
        final decodedData = jsonDecode(cachedData);
        final cacheItem = _CacheItem(
          data: decodedData['data'],
          timestamp: DateTime.parse(decodedData['timestamp']),
          duration: Duration(seconds: decodedData['duration']),
        );

        if (!cacheItem.isExpired) {
          // Update memory cache
          _memoryCache[key] = cacheItem;
          return cacheItem.data as T?;
        }
        
        // Remove expired data
        await prefs.remove(_cachePrefix + key);
      } catch (e) {
        await prefs.remove(_cachePrefix + key);
      }
    }
    return null;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    
    for (final key in keys) {
      await prefs.remove(key);
    }
    
    _memoryCache.clear();
    await DefaultCacheManager().emptyCache();
  }

  static Future<void> removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachePrefix + key);
    _memoryCache.remove(key);
  }
}

class _CacheItem {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  _CacheItem({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > duration;
}

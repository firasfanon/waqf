import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic methods for different data types

  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      debugPrint('Error setting string for key $key: $e');
      return false;
    }
  }

  String? getString(String key, [String? defaultValue]) {
    try {
      return _prefs?.getString(key) ?? defaultValue;
    } catch (e) {
      debugPrint('Error getting string for key $key: $e');
      return defaultValue;
    }
  }

  // Integer operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs?.setInt(key, value) ?? false;
    } catch (e) {
      debugPrint('Error setting int for key $key: $e');
      return false;
    }
  }

  int? getInt(String key, [int? defaultValue]) {
    try {
      return _prefs?.getInt(key) ?? defaultValue;
    } catch (e) {
      debugPrint('Error getting int for key $key: $e');
      return defaultValue;
    }
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs?.setBool(key, value) ?? false;
    } catch (e) {
      debugPrint('Error setting bool for key $key: $e');
      return false;
    }
  }

  bool? getBool(String key, [bool? defaultValue]) {
    try {
      return _prefs?.getBool(key) ?? defaultValue;
    } catch (e) {
      debugPrint('Error getting bool for key $key: $e');
      return defaultValue;
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs?.setDouble(key, value) ?? false;
    } catch (e) {
      debugPrint('Error setting double for key $key: $e');
      return false;
    }
  }

  double? getDouble(String key, [double? defaultValue]) {
    try {
      return _prefs?.getDouble(key) ?? defaultValue;
    } catch (e) {
      debugPrint('Error getting double for key $key: $e');
      return defaultValue;
    }
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs?.setStringList(key, value) ?? false;
    } catch (e) {
      debugPrint('Error setting string list for key $key: $e');
      return false;
    }
  }

  List<String>? getStringList(String key, [List<String>? defaultValue]) {
    try {
      return _prefs?.getStringList(key) ?? defaultValue;
    } catch (e) {
      debugPrint('Error getting string list for key $key: $e');
      return defaultValue;
    }
  }

  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      debugPrint('Error setting JSON for key $key: $e');
      return false;
    }
  }

  Map<String, dynamic>? getJson(String key, [Map<String, dynamic>? defaultValue]) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return defaultValue;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting JSON for key $key: $e');
      return defaultValue;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    try {
      return await _prefs?.remove(key) ?? false;
    } catch (e) {
      debugPrint('Error removing key $key: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      debugPrint('Error clearing storage: $e');
      return false;
    }
  }

  // Check if key exists
  bool containsKey(String key) {
    try {
      return _prefs?.containsKey(key) ?? false;
    } catch (e) {
      debugPrint('Error checking key $key: $e');
      return false;
    }
  }

  // Get all keys
  Set<String> getKeys() {
    try {
      return _prefs?.getKeys() ?? <String>{};
    } catch (e) {
      debugPrint('Error getting keys: $e');
      return <String>{};
    }
  }

  // App-specific convenience methods

  // Language preference
  Future<bool> setLanguage(String languageCode) async {
    return await setString(AppConstants.keyLanguage, languageCode);
  }

  String getLanguage() {
    return getString(AppConstants.keyLanguage, 'ar') ?? 'ar';
  }

  // Theme mode
  Future<bool> setThemeMode(String themeMode) async {
    return await setString(AppConstants.keyThemeMode, themeMode);
  }

  String getThemeMode() {
    return getString(AppConstants.keyThemeMode, 'system') ?? 'system';
  }

  // Notifications enabled
  Future<bool> setNotificationsEnabled(bool enabled) async {
    return await setBool(AppConstants.keyNotificationsEnabled, enabled);
  }

  bool getNotificationsEnabled() {
    return getBool(AppConstants.keyNotificationsEnabled, true) ?? true;
  }

  // User preferences
  Future<bool> setUserPreferences(Map<String, dynamic> preferences) async {
    return await setJson(AppConstants.keyUserPreferences, preferences);
  }

  Map<String, dynamic> getUserPreferences() {
    return getJson(AppConstants.keyUserPreferences, {}) ?? {};
  }

  // Last sync time
  Future<bool> setLastSyncTime(DateTime time) async {
    return await setString(AppConstants.keyLastSync, time.toIso8601String());
  }

  DateTime? getLastSyncTime() {
    final timeString = getString(AppConstants.keyLastSync);
    if (timeString == null) return null;
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      debugPrint('Error parsing last sync time: $e');
      return null;
    }
  }

  // Cache management methods

  // Set cache with expiration
  Future<bool> setCache(String key, dynamic value, {Duration? expiration}) async {
    try {
      final cacheData = {
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiration': expiration?.inMilliseconds,
      };
      return await setJson('cache_$key', cacheData);
    } catch (e) {
      debugPrint('Error setting cache for key $key: $e');
      return false;
    }
  }

  // Get cache if not expired
  T? getCache<T>(String key) {
    try {
      final cacheData = getJson('cache_$key');
      if (cacheData == null) return null;

      final timestamp = cacheData['timestamp'] as int?;
      final expiration = cacheData['expiration'] as int?;

      if (timestamp == null) return null;

      // Check if cache is expired
      if (expiration != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final expirationTime = cacheTime.add(Duration(milliseconds: expiration));

        if (DateTime.now().isAfter(expirationTime)) {
          // Cache expired, remove it
          remove('cache_$key');
          return null;
        }
      }

      return cacheData['value'] as T?;
    } catch (e) {
      debugPrint('Error getting cache for key $key: $e');
      return null;
    }
  }

  // Clear expired cache
  Future<void> clearExpiredCache() async {
    try {
      final keys = getKeys().where((key) => key.startsWith('cache_')).toList();

      for (final key in keys) {
        final cacheData = getJson(key);
        if (cacheData == null) continue;

        final timestamp = cacheData['timestamp'] as int?;
        final expiration = cacheData['expiration'] as int?;

        if (timestamp != null && expiration != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final expirationTime = cacheTime.add(Duration(milliseconds: expiration));

          if (DateTime.now().isAfter(expirationTime)) {
            await remove(key);
          }
        }
      }
    } catch (e) {
      debugPrint('Error clearing expired cache: $e');
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    try {
      final keys = getKeys().where((key) => key.startsWith('cache_')).toList();

      for (final key in keys) {
        await remove(key);
      }
    } catch (e) {
      debugPrint('Error clearing all cache: $e');
    }
  }

  // Bookmark management
  Future<bool> addBookmark(String type, int id) async {
    try {
      final bookmarks = getStringList('bookmarks_$type', []) ?? [];
      if (!bookmarks.contains(id.toString())) {
        bookmarks.add(id.toString());
        return await setStringList('bookmarks_$type', bookmarks);
      }
      return true;
    } catch (e) {
      debugPrint('Error adding bookmark: $e');
      return false;
    }
  }

  Future<bool> removeBookmark(String type, int id) async {
    try {
      final bookmarks = getStringList('bookmarks_$type', []) ?? [];
      bookmarks.remove(id.toString());
      return await setStringList('bookmarks_$type', bookmarks);
    } catch (e) {
      debugPrint('Error removing bookmark: $e');
      return false;
    }
  }

  List<int> getBookmarks(String type) {
    try {
      final bookmarks = getStringList('bookmarks_$type', []) ?? [];
      return bookmarks.map((id) => int.tryParse(id) ?? 0).where((id) => id > 0).toList();
    } catch (e) {
      debugPrint('Error getting bookmarks: $e');
      return [];
    }
  }

  bool isBookmarked(String type, int id) {
    return getBookmarks(type).contains(id);
  }

  // Search history
  Future<bool> addToSearchHistory(String query) async {
    try {
      final history = getStringList('search_history', []) ?? [];

      // Remove if already exists to avoid duplicates
      history.remove(query);

      // Add to beginning
      history.insert(0, query);

      // Keep only last 20 searches
      if (history.length > 20) {
        history.removeRange(20, history.length);
      }

      return await setStringList('search_history', history);
    } catch (e) {
      debugPrint('Error adding to search history: $e');
      return false;
    }
  }

  List<String> getSearchHistory() {
    return getStringList('search_history', []) ?? [];
  }

  Future<bool> clearSearchHistory() async {
    return await remove('search_history');
  }

  // Recently viewed items
  Future<bool> addToRecentlyViewed(String type, Map<String, dynamic> item) async {
    try {
      final recentItems = getJson('recent_$type', {'items': []}) ?? {'items': []};
      final items = List<Map<String, dynamic>>.from(recentItems['items'] ?? []);

      // Remove if already exists
      items.removeWhere((existingItem) => existingItem['id'] == item['id']);

      // Add to beginning
      items.insert(0, {
        ...item,
        'viewedAt': DateTime.now().toIso8601String(),
      });

      // Keep only last 50 items
      if (items.length > 50) {
        items.removeRange(50, items.length);
      }

      return await setJson('recent_$type', {'items': items});
    } catch (e) {
      debugPrint('Error adding to recently viewed: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> getRecentlyViewed(String type) {
    try {
      final recentItems = getJson('recent_$type', {'items': []}) ?? {'items': []};
      return List<Map<String, dynamic>>.from(recentItems['items'] ?? []);
    } catch (e) {
      debugPrint('Error getting recently viewed: $e');
      return [];
    }
  }

  Future<bool> clearRecentlyViewed(String type) async {
    return await remove('recent_$type');
  }
}
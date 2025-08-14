import 'dart:convert';
import 'package:newsapp/data/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences _prefs;
  static const String _newsKey = 'cached_news';
  static const String _timestampKey = 'cache_timestamp';
  static const Duration _cacheDuration = Duration(minutes: 30);

  CacheService(this._prefs);

  Future<void> cacheNews(List<NewsArticle> articles) async {
    try {
      final jsonList = articles.map((article) => article.toJson()).toList();
      final jsonString = json.encode(jsonList);

      await _prefs.setString(_newsKey, jsonString);
      await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching news: $e');
    }
  }

  Future<List<NewsArticle>?> getCachedNews() async {
    try {
      final timestamp = _prefs.getInt(_timestampKey);
      if (timestamp == null) return null;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      if (now.difference(cacheTime) > _cacheDuration) {
        await clearCache();
        return null;
      }

      final jsonString = _prefs.getString(_newsKey);
      if (jsonString == null) return null;

      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => NewsArticle.fromJson(json)).toList();
    } catch (e) {
      print('Error getting cached news: $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    await _prefs.remove(_newsKey);
    await _prefs.remove(_timestampKey);
  }

  bool isCacheValid() {
    final timestamp = _prefs.getInt(_timestampKey);
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    return now.difference(cacheTime) <= _cacheDuration;
  }
}

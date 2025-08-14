import 'package:newsapp/data/models/article.dart';
import 'package:newsapp/data/services/news_service.dart.dart';

import '../services/cache_service.dart';

class NewsRepository {
  final NewsService _newsService;
  final CacheService _cacheService;

  NewsRepository(this._newsService, this._cacheService);

  Future<List<NewsArticle>> getTopHeadlines({bool forceRefresh = false}) async {
    try {
      // Check cache first if not forcing refresh
      if (!forceRefresh && _cacheService.isCacheValid()) {
        final cachedNews = await _cacheService.getCachedNews();
        if (cachedNews != null && cachedNews.isNotEmpty) {
          return cachedNews;
        }
      }

      // Fetch from API
      final articles = await _newsService.fetchTopHeadlines();

      // Cache the results
      await _cacheService.cacheNews(articles);

      return articles;
    } catch (e) {
      // If API fails, try to return cached data
      final cachedNews = await _cacheService.getCachedNews();
      if (cachedNews != null && cachedNews.isNotEmpty) {
        return cachedNews;
      }
      rethrow;
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    return await _newsService.searchNews(query);
  }
}

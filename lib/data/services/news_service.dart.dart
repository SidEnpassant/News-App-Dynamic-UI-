import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp/data/models/article.dart';

class NewsService {
  // Replace with your actual API key from newsapi.org
  static const String _apiKey = '651a1dfc2ca345df91b92471cce8f6de';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({String country = 'us'}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;

        return articles
            .map((articleJson) => NewsArticle.fromJson(articleJson))
            .where((article) => article.title != '[Removed]')
            .take(20) // Cache only 20 items as required
            .toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything?q=$query&apiKey=$_apiKey&sortBy=publishedAt',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;

        return articles
            .map((articleJson) => NewsArticle.fromJson(articleJson))
            .where((article) => article.title != '[Removed]')
            .take(20)
            .toList();
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }
}

import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String source;
  final String? author;
  final String? content;

  const NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.source,
    this.author,
    this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: DateTime.parse(
        json['publishedAt'] ?? DateTime.now().toIso8601String(),
      ),
      source: json['source']['name'] ?? 'Unknown Source',
      author: json['author'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'source': {'name': source},
      'author': author,
      'content': content,
    };
  }

  @override
  List<Object?> get props => [
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    source,
    author,
    content,
  ];
}

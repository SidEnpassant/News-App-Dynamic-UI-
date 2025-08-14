import 'package:equatable/equatable.dart';
import 'package:newsapp/data/models/article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final bool isFromCache;

  const NewsLoaded(this.articles, {this.isFromCache = false});

  @override
  List<Object?> get props => [articles, isFromCache];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewsSearchLoading extends NewsState {}

class NewsSearchLoaded extends NewsState {
  final List<NewsArticle> articles;
  final String query;

  const NewsSearchLoaded(this.articles, this.query);

  @override
  List<Object?> get props => [articles, query];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;

  NewsBloc(this._newsRepository) : super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);
    on<RefreshNews>(_onRefreshNews);
    on<SearchNews>(_onSearchNews);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final articles = await _newsRepository.getTopHeadlines();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError('Failed to load news: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      final articles = await _newsRepository.getTopHeadlines(
        forceRefresh: true,
      );
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError('Failed to refresh news: ${e.toString()}'));
    }
  }

  Future<void> _onSearchNews(SearchNews event, Emitter<NewsState> emit) async {
    emit(NewsSearchLoading());
    try {
      final articles = await _newsRepository.searchNews(event.query);
      emit(NewsSearchLoaded(articles, event.query));
    } catch (e) {
      emit(NewsError('Failed to search news: ${e.toString()}'));
    }
  }
}

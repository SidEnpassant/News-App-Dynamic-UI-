import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/article.dart';
import '../data/repositories/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;

  NewsBloc({required this.newsRepository}) : super(NewsInitial()) {
    on<FetchNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await newsRepository.getTopHeadlines();
        emit(NewsLoaded(articles: articles));
      } catch (e) {
        emit(NewsError(message: e.toString()));
      }
    });
  }
}

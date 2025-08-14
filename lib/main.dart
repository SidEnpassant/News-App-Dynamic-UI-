import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp/data/services/news_service.dart.dart';
import 'package:newsapp/presentation/blocs/news_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/news_repository.dart';

import 'data/services/cache_service.dart';
import 'presentation/blocs/news_bloc.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final cacheService = CacheService(sharedPreferences);
  final newsService = NewsService();
  final newsRepository = NewsRepository(newsService, cacheService);

  runApp(NewsApp(newsRepository: newsRepository));
}

class NewsApp extends StatelessWidget {
  final NewsRepository newsRepository;

  const NewsApp({Key? key, required this.newsRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(newsRepository)..add(LoadNews()),
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/presentation/blocs/news_event.dart';
import 'package:newsapp/presentation/blocs/news_state.dart';
import 'package:newsapp/presentation/blocs/news_bloc.dart';
import '../widgets/news_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text('News App'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<NewsBloc>().add(RefreshNews());
            },
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomSearchBar(
                  onSearch: (query) {
                    if (query.isNotEmpty) {
                      context.read<NewsBloc>().add(SearchNews(query));
                    } else {
                      context.read<NewsBloc>().add(LoadNews());
                    }
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const ShimmerLoading();
                    } else if (state is NewsLoaded) {
                      return NewsList(
                        articles: state.articles,
                        isFromCache: state.isFromCache,
                      );
                    } else if (state is NewsSearchLoading) {
                      return const ShimmerLoading();
                    } else if (state is NewsSearchLoaded) {
                      return NewsList(
                        articles: state.articles,
                        searchQuery: state.query,
                      );
                    } else if (state is NewsError) {
                      return NewsErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<NewsBloc>().add(LoadNews());
                        },
                      );
                    }
                    return const Center(child: Text('Welcome to News App'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

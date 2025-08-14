import 'package:flutter/material.dart';
import 'package:newsapp/data/models/article.dart';

import 'news_card.dart';

class NewsList extends StatefulWidget {
  final List<NewsArticle> articles;
  final bool isFromCache;
  final String? searchQuery;

  const NewsList({
    Key? key,
    required this.articles,
    this.isFromCache = false,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(NewsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.articles != oldWidget.articles) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery != null
                  ? 'No articles found for "${widget.searchQuery}"'
                  : 'No articles available',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (widget.isFromCache)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.orange.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.offline_bolt, size: 16, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  'Showing cached news',
                  style: TextStyle(color: Colors.orange[700], fontSize: 12),
                ),
              ],
            ),
          ),
        if (widget.searchQuery != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Search results for "${widget.searchQuery}" (${widget.articles.length})',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Trigger refresh through parent widget
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.articles.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final animationValue = Curves.easeOutCubic.transform(
                      (_animationController.value * 2 - index * 0.1).clamp(
                        0.0,
                        1.0,
                      ),
                    );

                    return Transform.translate(
                      offset: Offset(0, (1 - animationValue) * 50),
                      child: Opacity(
                        opacity: animationValue,
                        child: NewsCard(
                          article: widget.articles[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/article.dart';
import 'article_tile.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;

  const ArticleList({
    Key? key,
    required this.articles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Center(child: Text('No articles found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleTile(article: articles[index]);
      },
    );
  }
} 
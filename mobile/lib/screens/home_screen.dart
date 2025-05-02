import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/article_list.dart';
import '../widgets/category_selector.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch headlines when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchTopHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jian News'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(themeProvider.isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selector
          CategorySelector(
            categories: newsProvider.categories,
            selectedCategory: newsProvider.currentCategory,
            onCategorySelected: (category) {
              newsProvider.changeCategory(category);
            },
          ),
          
          // News list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => newsProvider.fetchTopHeadlines(),
              child: newsProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : newsProvider.error.isNotEmpty
                      ? Center(child: Text(newsProvider.error))
                      : ArticleList(articles: newsProvider.headlines),
            ),
          ),
        ],
      ),
    );
  }
} 
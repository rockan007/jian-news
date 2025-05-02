import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/article_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _hasSearched = true;
      });
      context.read<NewsProvider>().searchNews(query: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    newsProvider.clearSearchResults();
                    setState(() {
                      _hasSearched = false;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _performSearch(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _hasSearched
                ? newsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : newsProvider.error.isNotEmpty
                        ? Center(child: Text(newsProvider.error))
                        : newsProvider.searchResults.isEmpty
                            ? const Center(child: Text('No results found'))
                            : ArticleList(articles: newsProvider.searchResults)
                : const Center(
                    child: Text('Search for news articles'),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _performSearch,
        child: const Icon(Icons.search),
      ),
    );
  }
} 
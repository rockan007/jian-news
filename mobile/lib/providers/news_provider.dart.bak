import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsProvider extends ChangeNotifier {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
  
  List<Article> _headlines = [];
  List<Article> _searchResults = [];
  String _currentCategory = 'general';
  bool _isLoading = false;
  String _error = '';

  List<Article> get headlines => _headlines;
  List<Article> get searchResults => _searchResults;
  String get currentCategory => _currentCategory;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Available news categories
  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Fetch top headlines
  Future<void> fetchTopHeadlines({
    String country = 'us',
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (category != null) {
      _currentCategory = category;
    }
    
    _setLoading(true);
    _error = '';
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/news/headlines?country=$country&category=${category ?? _currentCategory}&page=$page&pageSize=$pageSize'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final articles = (data['articles'] as List)
              .map((article) => Article.fromJson(article))
              .toList();
          
          _headlines = articles;
          notifyListeners();
        } else {
          _error = data['message'] ?? 'Failed to fetch headlines';
        }
      } else {
        _error = 'Failed to fetch headlines. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching headlines: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Search news
  Future<void> searchNews({
    required String query,
    String language = 'en',
    String? from,
    String? to,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    _error = '';
    
    try {
      var url = '$_baseUrl/news/search?q=$query&language=$language&page=$page&pageSize=$pageSize';
      
      if (from != null) url += '&from=$from';
      if (to != null) url += '&to=$to';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final articles = (data['articles'] as List)
              .map((article) => Article.fromJson(article))
              .toList();
          
          _searchResults = articles;
          notifyListeners();
        } else {
          _error = data['message'] ?? 'Failed to search news';
        }
      } else {
        _error = 'Failed to search news. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error searching news: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Change current category
  void changeCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;
      fetchTopHeadlines(category: category);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
} 
/*NewsService fetches Tesla + US business headlines from NewsAPI, enforcing a 20s timeout,
 requires `NEWS_API_KEY` from .env, safely casts/merges responses, deduplicates by URL,
 and returns a UI-ready `List<NewsItem>`, falling back to an empty list on errors.
 ...existing code...*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsService {
  static const Duration timeout = Duration(seconds: 20);

  String get _apiKey => dotenv.env['NEWS_API_KEY'] ?? '';

  /// Returns List<NewsItem> (matches your UI); supports optional query filtering
  /// and can optionally require an authenticated user for protected contexts.
  Future<List<NewsItem>> fetchNews({
    String query = '',
    bool requireAuth = false,
  }) async {
    try {
      if (requireAuth && Supabase.instance.client.auth.currentUser == null) {
        throw StateError('User must be authenticated to fetch news.');
      }

      print(
        'Fetching multi-source news (Tesla, business, WSJ, TechCrunch, Apple)...',
      );

      final apiKey = _apiKey;
      if (apiKey.isEmpty) {
        throw StateError(
          'NEWS_API_KEY is missing. Ensure .env is loaded before using NewsService.',
        );
      }

      final urls = [
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey',
        'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey',
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apiKey',
        'https://newsapi.org/v2/everything?q=tesla&from=2025-12-15&sortBy=publishedAt&apiKey=$apiKey',
        'https://newsapi.org/v2/everything?q=apple&from=2026-01-14&to=2026-01-14&sortBy=popularity&apiKey=$apiKey',
      ];

      final responses = await Future.wait(
        urls.map((u) => http.get(Uri.parse(u)).timeout(timeout)),
      );

      List<Map<String, dynamic>> allArticles = [];

      for (int i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          final data = jsonDecode(responses[i].body);
          if (data is Map<String, dynamic>) {
            final articles = data['articles'];
            if (articles is List) {
              allArticles.addAll(_safeCastArticles(articles));
            }
          }
        } else {
          print('Source ${i + 1} returned status ${responses[i].statusCode}');
        }
      }

      // Deduplicate + Parse to NewsItem
      final uniqueArticles = _deduplicateArticles(allArticles);
      final queryLower = query.trim().toLowerCase();
      final newsItems = uniqueArticles
          .map((json) => NewsItem.fromJson(json as Map<String, dynamic>))
          .where((item) => _matchesQuery(item, queryLower))
          .toList();

      print('Returning ${newsItems.length} NewsItem objects');
      return newsItems;
    } catch (e, stack) {
      print(' NewsService ERROR: $e\n$stack');
      return []; // Empty list fallback
    }
  }

  List<Map<String, dynamic>> _safeCastArticles(List articles) {
    return articles
        .map((item) {
          if (item is Map<String, dynamic>) return item;
          if (item is Map) return Map<String, dynamic>.from(item);
          return <String, dynamic>{};
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> _deduplicateArticles(
    List<Map<String, dynamic>> articles,
  ) {
    final seenUrls = <String>{};
    return articles.where((article) {
      final url = article['url']?.toString() ?? '';
      if (url.isNotEmpty && !seenUrls.contains(url)) {
        seenUrls.add(url);
        return true;
      }
      return false;
    }).toList();
  }

  bool _matchesQuery(NewsItem item, String queryLower) {
    if (queryLower.isEmpty) return true;
    return item.title.toLowerCase().contains(queryLower) ||
        item.subtitle.toLowerCase().contains(queryLower) ||
        item.source.toLowerCase().contains(queryLower);
  }
}

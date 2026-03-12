import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsService {
  static const Duration timeout = Duration(seconds: 20);

  String get _apiKey => dotenv.env['NEWS_API_KEY2'] ?? '';

  /// Returns List<NewsItem> (matches your UI)
  Future<List<NewsItem>> fetchNews() async {
    try {
      print(' Fetching news from multiple endpoints...');

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
        urls.map((url) => http.get(Uri.parse(url)).timeout(timeout)),
      );

      List<Map<String, dynamic>> allArticles = [];

      for (var i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          final data = jsonDecode(responses[i].body);
          if (data is Map<String, dynamic>) {
            final articles = data['articles'];
            if (articles is List) {
              allArticles.addAll(_safeCastArticles(articles));
            }
          }
        } else {
          print('Endpoint ${i + 1} failed: ${responses[i].statusCode}');
        }
      }

      // Deduplicate + Parse to NewsItem
      final uniqueArticles = _deduplicateArticles(allArticles);
      final newsItems = uniqueArticles
          .map((json) => NewsItem.fromJson(json as Map<String, dynamic>))
          .toList();

      print('Returning ${newsItems.length} NewsItem objects');
      return newsItems;
    } catch (e, stack) {
      print('NewsService ERROR: $e\n$stack');
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
}

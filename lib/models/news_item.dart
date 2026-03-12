class NewsItem {
  final String source;
  final String timeAgo;
  final String title;
  final String subtitle;
  final String category;
  final String imageUrl;
  final String url;

  NewsItem({
    required this.source,
    required this.timeAgo,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.url,
  });

  /// ✅ Accepts Map<String, dynamic> (from NewsAPI)

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      source: json['source']?['name'].toString() ?? '',
      timeAgo: _formatTimeAgo(json['publishedAt']),
      title: json['title']?.toString() ?? '',
      subtitle: json['description']?.toString() ?? '',
      category: 'business', // Or parse from source/title
      imageUrl: json['urlToImage']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'timeAgo': timeAgo,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'imageUrl': imageUrl,
      'url': url,
    };
  }

  static String _formatTimeAgo(String? publishedAt) {
    if (publishedAt == null) return '';
    // Basic formatter (add timeago package for full)
    return publishedAt.substring(0, 10); // 2026-01-11
  }
}

/*
  Home screen scaffold that renders the main feed, wires bottom navigation,
  and coordinates navigation to news, groups, notifications, and profile sections.
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../services/news_service.dart';
import '../../models/news_item.dart'; //
import 'top_app_bar.dart';
import 'create_post_box.dart';
import 'news_card.dart';
import '../post/post_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_page.dart';
import 'bottom_nav.dart';
import '../users/user_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsService _newsService = NewsService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<NewsItem>> newsFuture;
  int currentIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    newsFuture = _loadNews();
  }

  Future<List<NewsItem>> _loadNews({String query = ''}) async {
    try {
      return await _newsService.fetchNews(query: query, requireAuth: false);
    } catch (e) {
      print('API failed, using local fallback: $e');
      return _loadLocalNews(query: query);
    }
  }

  Future<List<NewsItem>> _loadLocalNews({String query = ''}) async {
    final jsonStr = await rootBundle.loadString('assets/news/share.json');
    final List<dynamic> data = json.decode(jsonStr) as List<dynamic>;
    final items = data
        .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
        .toList();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((item) => _matchesQuery(item, q)).toList();
  }

  bool _matchesQuery(NewsItem item, String q) {
    return item.title.toLowerCase().contains(q) ||
        item.subtitle.toLowerCase().contains(q) ||
        item.source.toLowerCase().contains(q);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      newsFuture = _loadNews(query: _searchQuery);
    });
  }

  void onNavTap(int i) {
    if (i == currentIndex) return;
    switch (i) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserListPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PostPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      default:
        setState(() => currentIndex = i);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: TopAppBar(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreatePostBox(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: 'Search news or topics...',
            ),
            Expanded(
              child: FutureBuilder<List<NewsItem>>(
                future: newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          ElevatedButton(
                            onPressed: () => setState(
                              () => newsFuture = _loadNews(query: _searchQuery),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  final items = snapshot.data ?? [];
                  return RefreshIndicator(
                    onRefresh: () => Future.value(
                      newsFuture = _loadNews(query: _searchQuery),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          NewsCard(item: items[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onChanged: onNavTap,
      ),
    );
  }
}

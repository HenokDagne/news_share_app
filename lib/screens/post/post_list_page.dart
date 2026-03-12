/*
  Lists posts with pull-to-refresh, shows loading states,
  and wires edit/delete callbacks for each PostCard.
*/

import 'package:flutter/material.dart';
import 'post_fetcher.dart';
import 'post_card.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostFetcher fetcher = PostFetcher();
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => isLoading = true);
    try {
      posts = await fetcher.fetchPosts();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load posts')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && posts.isEmpty) {
      // Show loading indicator if initial load
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20, top: 4),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(
            postId: post['id']?.toString() ?? '',
            postUserId: post['user_id']?.toString(),
            title: post['title']?.toString() ?? '',
            content: post['content']?.toString() ?? '',
            imageUrl: post['image_url']?.toString(),
            createdAt: post['created_at'] != null
                ? DateTime.tryParse(post['created_at'])
                : null,
            onEdit: () {
              // TODO: implement edit action
            },
            onDelete: () {
              // TODO: implement delete action
              setState(() {
                posts.removeAt(index);
              });
            },
            isLoading: isLoading, // optional, shows skeleton if true
          );
        },
      ),
    );
  }
}

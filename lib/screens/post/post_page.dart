// ...existing code...
/*
  Renders the post screen: lets users enter title/content, pick/upload an image,
  publish via PostService, shows publish feedback, and displays the post feed.
  Also handles bottom navigation to Home, Users, Notifications, and Profile.
*/
// ...existing code...

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/top_app_bar.dart';
import '../home/bottom_nav.dart';
import '../home/home_page.dart';
import '../notification/notification_page.dart';
import '../profile/profile_page.dart';
import 'post_area.dart';
import 'post_photo.dart';
import 'publish_button.dart';
import 'post_service.dart';
import 'post_list_page.dart';
import '../users/user_list.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _currentIndex = 2;
  bool _uploading = false;

  final GlobalKey<PostPhotoState> postPhotoKey = GlobalKey<PostPhotoState>();

  final SupabaseClient supabase = Supabase.instance.client;
  late final PostArea postArea;

  String? fullName;
  String? avatarUrl;

  bool get _isAuthenticated => supabase.auth.currentUser != null;

  @override
  void initState() {
    super.initState();
    postArea = PostArea();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('profiles')
        .select('full_name, avatar_url')
        .eq('id', user.id)
        .single();

    setState(() {
      fullName = data['full_name'];
      avatarUrl = data['avatar_url'];
    });
  }

  Future<void> _publishPost() async {
    if (!_isAuthenticated) {
      return;
    }

    final title = postArea.titleController.text.trim();
    final content = postArea.contentController.text.trim();
    String? imageUrl;

    final mediaPath = postPhotoKey.currentState?.selectedMediaPath;

    if (mediaPath != null) {
      setState(() => _uploading = true);
      imageUrl = await PostService().uploadImage(File(mediaPath));
      setState(() => _uploading = false);
    }

    if (title.isEmpty && content.isEmpty && imageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add content or image')));
      return;
    }

    final success = await PostService().createPost(
      title: title.isNotEmpty ? title : null,
      content: content.isNotEmpty ? content : null,
      imageUrl: imageUrl,
    );

    if (success) {
      postArea.titleController.clear();
      postArea.contentController.clear();
      postPhotoKey.currentState?.clearMedia();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post published')));
    }
  }

  void _onNavTap(int i) {
    if (i == _currentIndex) return;

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
    if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserListPage()),
      );
    }
    if (i == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotificationPage()),
      );
    }
    if (i == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: TopAppBar(),
      ),
      body: Column(
        children: [
          if (_isAuthenticated)
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    postArea,
                    const SizedBox(height: 12),
                    PostPhoto(key: postPhotoKey),
                    if (_uploading)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 12),
                    PublishButton(onPressed: _publishPost),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Browsing as a guest. Sign in to publish posts.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

          const Expanded(flex: 7, child: PostListPage()),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onChanged: _onNavTap,
      ),
    );
  }
}

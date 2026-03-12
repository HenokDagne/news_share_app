/*
  Renders the search/input box used on the feed; forwards text changes so
  callers can filter posts/news (e.g., NewsService search) or handle post creation.
*/
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePostBox extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const CreatePostBox({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = "What's on your mind?",
  });

  @override
  State<CreatePostBox> createState() => _CreatePostBoxState();
}

class _CreatePostBoxState extends State<CreatePostBox> {
  String? _avatarUrl;
  bool _isLoggedIn = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => _isLoggedIn = false);
        return;
      }

      setState(() => _isLoggedIn = true);

      final data = await supabase
          .from('profiles')
          .select('avatar_url')
          .eq('id', user.id)
          .single();

      if (!mounted) return;
      final url = (data['avatar_url'] ?? '').toString();
      setState(() {
        _avatarUrl = url.isNotEmpty ? url : null;
      });
    } catch (e) {
      debugPrint('CreatePostBox avatar fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final showRing = _isLoggedIn;

    return Container(
      margin: EdgeInsets.only(top: 4),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (showRing)
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A00), Color(0xFFCC2E5D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: _avatar(radius: 24),
            )
          else
            _avatar(radius: 24),
          const SizedBox(width: 12),
          Expanded(
            
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CircleAvatar _avatar({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF7C3AED),
      backgroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty
          ? NetworkImage(_avatarUrl!)
          : null,
      child: (_avatarUrl == null || _avatarUrl!.isEmpty)
          ? const Icon(Icons.person, color: Colors.white)
          : null,
    );
  }
}

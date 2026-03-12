/*
  Renders a user card with avatar, name, and follow/unfollow button,
  initializes follow state from Supabase, and shows a loading spinner while updating.
*/

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_model.dart';
import 'follow_handler.dart';

class UserCard extends StatefulWidget {
  final UserItem user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final FollowHandler _followHandler = FollowHandler();
  late bool _isFollowing;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;

    // Fetch the actual follow state from Supabase
    _initFollowState();
  }

  Future<void> _initFollowState() async {
    try {
      final following = await _followHandler.isFollowing(widget.user.id);
      if (mounted) setState(() => _isFollowing = following);
    } catch (e) {
      debugPrint('Error checking follow state: $e');
    }
  }

  Future<void> _toggleFollow() async {
    setState(() => _loading = true);

    try {
      if (_isFollowing) {
        await _followHandler.unfollow(widget.user.id);
        if (mounted) setState(() => _isFollowing = false);
      } else {
        await _followHandler.follow(widget.user.id);
        if (mounted) setState(() => _isFollowing = true);
      }
    } catch (e) {
      debugPrint('Follow/unfollow error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update follow status')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with tap to profile
            widget.user.buildAvatar(context, size: 50),
            const SizedBox(width: 16),
            // Name and follow button in a column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.full_name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isAuthenticated) ...[
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _toggleFollow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? Colors.grey[300]
                              : Colors.blue,
                          foregroundColor: _isFollowing
                              ? Colors.black
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isFollowing ? 'Unfollow' : 'Follow'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

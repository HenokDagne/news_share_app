/*
  Defines UserItem model, builds avatars with fallback + profile navigation,
  and exposes a helper to fetch users via UserFetcher.
*/

import 'package:flutter/material.dart';
import '../profile/profile_page.dart';
import 'user_fetcher.dart';

class UserItem {
  final String id;
  final String full_name;
  final String avatarUrl;
  bool isFollowing;

  UserItem({
    required this.id,
    required this.full_name,
    required this.avatarUrl,
    this.isFollowing = false,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: (json['id'] ?? '').toString(),
      full_name: (json['full_name'] ?? '').toString(),
      avatarUrl: (json['avatar_url'] ?? '').toString(), // match Supabase field
      isFollowing: json['is_following'] == true,
    );
  }

  /// Fetch users via UserFetcher
  static Future<List<UserItem>> fetchUsers() async {
    final fetcher = UserFetcher();
    return await fetcher.fetchUsers();
  }

  /// Builds avatar widget with fallback and navigation to profile
  Widget buildAvatar(BuildContext context, {double size = 50}) {
    final Widget avatarWidget = avatarUrl.isEmpty
        ? _fallbackAvatar(context, size)
        : ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.network(
              avatarUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _fallbackAvatar(context, size);
              },
            ),
          );

    return InkWell(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
      },
      child: avatarWidget,
    );
  }

  Widget _fallbackAvatar(BuildContext context, double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey.shade300,
      child: IconButton(
        icon: const Icon(Icons.person, color: Colors.white),
        tooltip: 'View profile',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        },
      ),
    );
  }
}

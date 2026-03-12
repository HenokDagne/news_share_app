// lib/notification/notification.dart
/*
  Defines NotificationData model, loads notifications for the current user,
  builds safe avatar widgets with fallbacks, and links to the Profile page.
*/
import 'package:flutter/material.dart';
import '../profile/profile_page.dart';
import 'push_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationData {
  final String avatar;
  final String message;
  final String time;

  NotificationData({
    required this.avatar,
    required this.message,
    required this.time,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      avatar: json['actor_avatar_url'] ?? '',
      message: json['message'] ?? '',
      time: json['created_at']?.toString() ?? '',
    );
  }

  static Future<List<NotificationData>> readNotifications() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await PushNotificationService.fetchUserNotifications(userId);
    return data.map((e) => NotificationData.fromJson(e)).toList();
  }

  /// Safe avatar widget with fallback if network image fails
  Widget buildAvatar(BuildContext context, {double size = 50}) {
    final Widget avatarWidget = avatar.isEmpty
        ? _fallbackAvatar(context, size)
        : ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.network(
              avatar,
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
          // navigate to profile page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        },
      ),
    );
  }
}

// lib/user/follow_stats_box.dart
/*
  Fetches and displays follower/following counts for a user,
  shows a skeleton while loading, and renders a clean two-column stats box.
*/

import 'package:flutter/material.dart';
import 'user_follow_fetcher.dart';
import 'follow_stats_skeleton.dart';

class FollowStatsBox extends StatefulWidget {
  final String userId;

  const FollowStatsBox({super.key, required this.userId});

  @override
  State<FollowStatsBox> createState() => _FollowStatsBoxState();
}

class _FollowStatsBoxState extends State<FollowStatsBox> {
  final _fetcher = UserFollowFetcher();

  @override
  void didUpdateWidget(covariant FollowStatsBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      setState(() {}); // Triggers rebuild and refetch
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserFollowData?>(
      // Always fetch fresh data on build for up-to-date stats
      future: _fetcher.fetchFollowStats(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const FollowStatsSkeleton();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 60,
            child: Center(child: Text('Stats unavailable')),
          );
        }

        final data = snapshot.data!;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _item('Followers', data.followersCount),
              _divider(),
              _item('Following', data.followingCount),
            ],
          ),
        );
      },
    );
  }

  Widget _item(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}

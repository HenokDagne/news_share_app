// lib/user/follow_handler.dart
/*
  Handles Supabase follow/unfollow operations via RPC calls,
  checks follow status, and can fetch follower/following counts.
*/
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowHandler {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Follow the target user by calling RPC 'follow_user'
  Future<void> follow(String targetUserId) async {
    try {
      await supabase.rpc(
        'follow_user',
        params: {'target_user': targetUserId}, // matches RPC argument
      );
      // Optional: print success
      print('Followed user $targetUserId successfully.');
    } catch (e, stack) {
      print('Follow error: $e');
      print('Stack trace: $stack');
    }
  }

  /// Unfollow the target user by calling RPC 'unfollow_user'
  Future<void> unfollow(String targetUserId) async {
    try {
      await supabase.rpc(
        'unfollow_user',
        params: {'target_user': targetUserId}, // matches RPC argument
      );
      // Optional: print success
      print('Unfollowed user $targetUserId successfully.');
    } catch (e, stack) {
      print('Unfollow error: $e');
      print('Stack trace: $stack');
    }
  }

  /// Check if the currently authenticated user follows the target user
  Future<bool> isFollowing(String targetUserId) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return false;
      }

      final data = await supabase
          .from('followers')
          .select()
          .eq('follower_id', currentUserId)
          .eq('following_id', targetUserId)
          .maybeSingle();

      return data != null;
    } catch (e, stack) {
      print('isFollowing error: $e');
      print('Stack trace: $stack');
      return false;
    }
  }

  /// Optional: fetch the number of followers/following for a specific user
  Future<Map<String, int>> fetchFollowCounts(String userId) async {
    try {
      final data = await supabase
          .from('profiles')
          .select('followers_count, following_count')
          .eq('id', userId)
          .single();

      return {
        'followers_count': data['followers_count'] ?? 0,
        'following_count': data['following_count'] ?? 0,
      };
    } catch (e, stack) {
      print('fetchFollowCounts error: $e');
      print('Stack trace: $stack');
      return {'followers_count': 0, 'following_count': 0};
    }
  }
}

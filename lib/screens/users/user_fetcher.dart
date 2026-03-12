/*
  Fetches users from the Supabase 'profiles' table, orders by full_name,
  and returns all except the currently logged-in user as UserItem models.
*/

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_model.dart';

class UserFetcher {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetch all users from the 'profiles' table except the current logged-in user
  Future<List<UserItem>> fetchUsers() async {
    try {
      // Get current user ID
      final currentUser = supabase.auth.currentUser;
      final currentUserId = currentUser?.id;

      final data = await supabase.from('profiles').select().order('full_name');

      if (data == null) return [];

      // Exclude current user from the list
      return (data as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => UserItem.fromJson(e))
          .where((user) => user.id != currentUserId)
          .toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }
}

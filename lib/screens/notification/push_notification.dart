/*
  Fetches a user's notifications from Supabase, filtered by user_id and ordered by latest first.
*/
import 'package:supabase_flutter/supabase_flutter.dart';

class PushNotificationService {
  static Future<List<Map<String, dynamic>>> fetchUserNotifications(
    String userId,
  ) async {
    final response = await Supabase.instance.client
        .from('notifications')
        .select()
        .filter('user_id', 'eq', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}

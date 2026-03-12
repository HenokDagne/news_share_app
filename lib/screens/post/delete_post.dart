
/*
  Deletes a post in Supabase only if it belongs to the current logged-in user.
*/
import 'package:supabase_flutter/supabase_flutter.dart';

class DeletePostService {
  static Future<void> deletePost(String postId) async {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    final currentUserId = currentUser?.id;
    if (currentUserId == null) {
      throw Exception('User not logged in');
    }
    // Only delete if the post belongs to the current user
    final response = await supabase
        .from('posts')
        .delete()
        .eq('id', postId)
        .eq('user_id', currentUserId);
    // Optionally, check for errors if using postgrest v1
    // if (response.error != null) {
    //   throw Exception('Failed to delete post: \\${response.error!.message}');
    // }
  }
}

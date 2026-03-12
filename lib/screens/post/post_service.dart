/*
  Provides Supabase-backed post utilities: uploads images to the "posts" bucket
  and creates posts in the "posts" table with optional title, content, and image URL.
*/

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Upload image to Supabase Storage 'posts' bucket and return public URL
 Future<String?> uploadImage(File file) async {
  try {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    print('Uploading file: $fileName');

    // Upload file to Supabase Storage bucket 'posts'
    await supabase.storage
        .from('posts')
        .upload(fileName, file, fileOptions: const FileOptions(cacheControl: '3600'));

    print('File uploaded successfully.');

    // Generate public URL
    final publicUrl = supabase.storage.from('posts').getPublicUrl(fileName);

    print('Public URL: $publicUrl');

    return publicUrl; // Store this in the 'posts' table
  } on StorageException catch (e) {
    // Only use message
    print('Supabase StorageException: ${e.message}');
    return null;
  } catch (e, stackTrace) {
    print('Unexpected error uploading image: $e');
    print(stackTrace);
    return null;
  }
}

  /// Create a post in Supabase 'posts' table
  Future<bool> createPost({
    String? title,
    String? content,
    String? imageUrl,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      final data = {
        'user_id': user.id,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (imageUrl != null) 'image_url': imageUrl,
      };

      final response = await supabase.from('posts').insert(data).select();

      if (response == null || response.isEmpty) {
        print('Failed to create post in table.');
        return false;
      }

      print('Post created: ${response[0]}');
      return true;
    } catch (e, stackTrace) {
      print('Error creating post: $e');
      print(stackTrace);
      return false;
    }
  }
}

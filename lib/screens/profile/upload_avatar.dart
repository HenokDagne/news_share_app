/*
  Picks an avatar from the gallery, uploads it to Supabase Storage (upsert),
  updates the profiles table with the public URL, and triggers a profile reload.
*/

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pick a temporary avatar image from gallery
Future<File?> pickTempAvatar(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    return null;
  }
}

/// Upload avatar file to Supabase Storage and update profiles table
Future<void> saveAvatarToSupabase({
  required BuildContext context,
  required SupabaseClient supabase,
  required File file,
  required Future<void> Function() reloadProfile,
}) async {
  final user = supabase.auth.currentUser;
  if (user == null) return;

  try {
    final fileExt = file.path.split('.').last;
    final fileName = '${user.id}/avatar.$fileExt';


    // Upload to Supabase Storage
    await supabase.storage
        .from('avatars')
        .upload(
          fileName,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    // Get public URL
    final publicUrl =
        supabase.storage.from('avatars').getPublicUrl(fileName);

    // Update profiles table
    await supabase
        .from('profiles')
        .update({'avatar_url': publicUrl})
        .eq('id', user.id);

    await reloadProfile();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture saved!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving image: $e')),
    );
  }
}

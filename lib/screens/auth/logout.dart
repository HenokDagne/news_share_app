// lib/handlers/logout_handler.dart
// LOGOUT ONLY - No login functionality
// Handles sign-out for Supabase and Google, shows a success/failure SnackBar, and guards UI ops with context.mounted.
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutHandler {
  final supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> handleLogout(BuildContext context) async {
    try {
      final userEmail = supabase.auth.currentUser?.email;  
      print('Logging out $userEmail...');

      await supabase.auth.signOut();
      await _googleSignIn.signOut();

      print(' Logout complete for $userEmail');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged out successfully, ${userEmail ?? "User"}!'),  
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );


        

       
      }
    } catch (e) {
      _showError(context, 'Logout failed: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}

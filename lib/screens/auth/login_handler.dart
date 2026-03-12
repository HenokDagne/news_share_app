// ...existing code...
/*
  Handles Supabase email/password login, validates the form, shows SnackBars, routes to Home on success,
  and surfaces friendly error messages for common auth failures.
*/
// ...existing code...

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:news_share/screens/home/home_page.dart';

class LoginHandler {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> handleLoginSubmit(
    GlobalKey<FormState> formKey,
    BuildContext context, // Added for navigation/errors
  ) async {
    print('\n=== SUPABASE LOGIN START ===');
    print('Email: ${emailController.text.trim()}');

    if (formKey.currentState!.validate()) {
      print('Form validation passed');
      try {
        print('Calling supabase.auth.signInWithPassword()...');

        final response = await supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        print('Login response: $response');
       

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } on AuthException catch (e) {
        print('AuthException: ${e.message}');
        print('Status code: ${e.statusCode}');
        _showError(context, _errorMessage(e.message));
      } catch (e) {
        print('Unexpected error: $e');
        _showError(context, 'Login failed: $e');
      }
    } else {
      print('Form validation FAILED');
    }
    print('=== LOGIN END ===\n');
  }

  String _errorMessage(String message) {
    print('Raw error: $message');
    switch (message) {
      case 'Invalid login credentials':
        return 'Wrong email or password';
      case 'Email not confirmed':
        return 'Please confirm your email first';
      case 'Too many requests':
        return 'Too many login attempts. Try again later';
      default:
        return message;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

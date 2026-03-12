// Handles Supabase email/password signup, surfaces tailored error messages, shows SnackBars, and routes to Home on success.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:news_share/screens/home/home_page.dart';

class SignupHandler {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> handleSignUpSubmit(
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      print('Form validation passed');
      try {
        print('Calling supabase.auth.signUp()...');

        // Supabase signup
        final response = await supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        print('Signup response: $response');
        print('Response.user: ${response.user}');

        final user = response.user;
        if (user != null) {
          print('Signup SUCCESS! User ID: ${user.id}');
          print('User email: ${user.email}');

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Welcome ${user.email}!')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          print('No user returned in response');
          _showError(context, 'Signup failed - no user returned');
        }
      } on AuthException catch (e) {
        print('AuthException: ${e.message}');
        print('AuthException code: ${e.statusCode}');
        _showError(context, _errorMessage(e.message));
      } catch (e) {
        print(' Unexpected error: $e');
        print('Error type: ${e.runtimeType}');
        _showError(context, 'Unexpected error: $e');
      }
    } else {
      print('Form validation FAILED');
    }
  }

  String _errorMessage(String message) {
    print('Raw error message: $message');
    switch (message) {
      case 'Invalid login credentials':
        return 'Invalid email or password';
      case 'User already registered':
        return 'Email already exists. Try login.';
      case 'Email not confirmed':
        return 'Please check your email.';
      case 'Password should be at least 6 characters':
        return 'Password must be 6+ characters';
      default:
        return message;
    }
  }

  void _showError(BuildContext context, String message) {
    print('Showing error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

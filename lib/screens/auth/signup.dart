/*
  Handles Supabase email/password signup, validates the form, shows SnackBars,
  surfaces friendly error messages, and routes to Home on success.
*/


import 'package:flutter/material.dart';
import 'widgets/top_bar.dart';
import 'widgets/inputbox.dart';
import 'widgets/inputbutton.dart';
import 'widgets/footer.dart';
import 'signup_handler.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _handler = SignupHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TopBar(),
                const SizedBox(height: 24),
                InputBox(
                 
                  emailController: _handler.emailController,
                  passwordController: _handler.passwordController,
                ),
                const SizedBox(height: 24),
                InputButton(
                  formKey: _formKey,  // 👈 Pass the formKey
                  onSubmit: () => _handler.handleSignUpSubmit(_formKey, context),
                ),
                const SizedBox(height: 16),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }
}

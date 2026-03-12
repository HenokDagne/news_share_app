import 'package:flutter/material.dart';
import 'package:news_share/screens/auth/signup.dart';
//import '../signup.dart';



class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  const LoginButton({super.key, required this.formKey, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0095F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: onSubmit,
            child: const Text(
              'Log In',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            } else {
              // If no route to pop, go to home or close app
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignUpPage() )
              );
            }
          },
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.grey),
              children: [
                const TextSpan(text: 'Don\'t have an account? '),
                TextSpan(
                  text: 'Create new account',
                  style: const TextStyle(
                    color: Color(0xFF0095F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

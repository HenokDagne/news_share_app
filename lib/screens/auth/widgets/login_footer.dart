import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 👇 FIXED: Added onChanged (required parameter)
        DropdownButton<String>(
          value: 'English',
          underline: Container(),
          onChanged: (String? newValue) {}, // 👈 Empty function (decorative)
          items: const [
            DropdownMenuItem(value: 'English', child: Text('English')),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('Privacy'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Terms'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Cookies'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '© 2025 Authflow',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

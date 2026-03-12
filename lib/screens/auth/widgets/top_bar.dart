import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // back + title row
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48), // to balance the back button width
          ],
        ),
        const SizedBox(height: 24),

        // Blue square icon (key/lock style)
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF0095F6),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.lock, // key / lock type icon
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Create an Account',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

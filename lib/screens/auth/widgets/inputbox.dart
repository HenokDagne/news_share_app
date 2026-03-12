import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const InputBox({
    super.key,
    
    required this.emailController,
    required this.passwordController,
  });

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0095F6), width: 1.3),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );

  TextStyle get _labelStyle => const TextStyle(
        fontSize: 12,
        color: Color(0xFF8E8E8E),
        fontWeight: FontWeight.w500,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Text('Email', style: _labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _fieldDecoration('Email'),
          validator: (v) => v?.contains('@') != true ? 'Valid email required' : null,
        ),
        const SizedBox(height: 18),
        Text('New Password', style: _labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: _fieldDecoration('Create a strong password'),
          validator: (v) => v?.length != null && v!.length < 6 ? 'Min 6 chars' : null,
        ),
        const SizedBox(height: 26),
      ],
    );
  }
}

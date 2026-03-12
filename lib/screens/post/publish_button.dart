/*
  Renders a publish/submit button, wires its onPressed callback,
  and can show loading/disabled states while publishing.
*/

import 'package:flutter/material.dart';

class PublishButton extends StatefulWidget {
  /// Callback triggered when button is pressed
  final Future<void> Function()? onPressed;

  const PublishButton({super.key, this.onPressed});

  @override
  State<PublishButton> createState() => _PublishButtonState();
}

class _PublishButtonState extends State<PublishButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;

    setState(() => _isLoading = true);

    try {
      await widget.onPressed!();
    } catch (e) {
      debugPrint('Error during publish: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Increase width as needed
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Publish"),
      ),
    );
  }
}

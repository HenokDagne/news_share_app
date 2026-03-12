/*
  Renders a post composer with title and content fields,
  exposes controllers via the widget, and disposes them safely on unmount.
*/
import 'package:flutter/material.dart';

class PostArea extends StatefulWidget {
  // Removed 'const' here because of controllers
  PostArea({super.key});

  // Expose controllers publicly
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  State<PostArea> createState() => _PostAreaState();
}

class _PostAreaState extends State<PostArea> {
  @override
  void dispose() {
    widget.titleController.dispose();
    widget.contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Title TextField
              TextField(
                controller: widget.titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Divider(height: 20),

              // Content TextField
              TextField(
                controller: widget.contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Share news or your thoughts...',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

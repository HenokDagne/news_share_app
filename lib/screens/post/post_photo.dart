/*
  Lets users pick an image or video from the gallery, tracks the selected media state,
  and previews the chosen item (image or video placeholder) with simple action buttons.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPhoto extends StatefulWidget {
  const PostPhoto({super.key});

  @override
  PostPhotoState createState() => PostPhotoState();
}

class PostPhotoState extends State<PostPhoto> {
  final ImagePicker picker = ImagePicker();
  String? selectedMediaPath;
  bool isVideo = false;

  Future<void> pickImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedMediaPath = image.path;
        isVideo = false;
      });
    }
  }

  Future<void> pickVideo() async {
    final XFile? video =
        await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        selectedMediaPath = video.path;
        isVideo = true;
      });
    }
  }

  void clearMedia() {
    setState(() {
      selectedMediaPath = null;
      isVideo = false;
    });
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Action buttons container
        Container(
          
          height: 90,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton(
                icon: Icons.photo,
                label: 'Image',
                onTap: pickImage,
              ),
              const SizedBox(width: 12),
              _actionButton(
                icon: Icons.videocam,
                label: 'Video',
                onTap: pickVideo,
              ),
            ],
          ),
        ),

        // Media preview
        if (selectedMediaPath != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isVideo
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 64,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : Image.file(
                      File(selectedMediaPath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
      ],
    );
  }
}

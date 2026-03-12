/*
  Stateless card widget that renders a NewsItem with image, title, description,
  source info, and supports tap handling for navigation or external links.
*/

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../models/news_item.dart';
import 'package:share_plus/share_plus.dart';

class NewsCard extends StatefulWidget {
  final NewsItem? item;
  final bool isLoading;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NewsCard({
    super.key,
    this.item,
    this.isLoading = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  void _shareDirect(BuildContext context, String shareText) async {
    await _shareGeneric(shareText);
  }

  Widget _shareItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      onTap: onTap,
    );
  }

  Future<void> _shareGeneric(String text) async {
    await Share.share(text);
  }

  bool _isExpanded = false;

  // ----------------- HELPER: Convert title/subtitle to string -----------------
  String _extractText(dynamic field) {
    if (field == null) return '';
    // If field is a Map
    if (field is Map<String, dynamic>) {
      final name = field['name'] ?? '';
      return name; 
    }
    // If field is a class/object with .name
    try {
      final name = field.name ?? '';
      return name;
    } catch (_) {}
    // Otherwise, treat as string
    return field.toString();
  }

  // ----------------- SKELETON -----------------
  Widget _skeleton({double height = 14, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _skeleton(height: 44, width: 44),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _skeleton(width: 120),
                        const SizedBox(height: 6),
                        _skeleton(width: 80),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _skeleton(width: 24, height: 24),
                ],
              ),
              const SizedBox(height: 12),
              _skeleton(width: double.infinity, height: 20),
              const SizedBox(height: 6),
              _skeleton(width: double.infinity, height: 16),
              const SizedBox(height: 6),
              _skeleton(width: 100, height: 16),
              const SizedBox(height: 12),
              Container(height: 180, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              _skeleton(width: double.infinity, height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- DESCRIPTION WITH SEE MORE -----------------
  Widget _buildDescription(String text) {
    final shouldShowExpand = text.length > 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isExpanded
              ? text
              : (text.substring(0, shouldShowExpand ? 100 : text.length) +
                    (shouldShowExpand ? '...' : '')),
          style: const TextStyle(color: Colors.grey),
        ),
        if (shouldShowExpand)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _isExpanded ? 'See less' : 'See more',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ----------------- IMAGE -----------------
  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 180,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, size: 60, color: Colors.white),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: 180,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.broken_image, size: 60, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _buildSkeleton();

    final item = widget.item!;
    final titleText = _extractText(item.title);
    final subtitleText = _extractText(item.subtitle);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                          Color(0xFF515BD4),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        color: Color(0xFF7C3AED),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.source,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              item.timeAgo,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.public,
                              size: 12,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ----------------- 3 DOT MENU (Overflow) -----------------
                  IconButton(
                    icon: const Icon(Icons.share, color: Color(0xFF2563EB)),
                    tooltip: 'Share',
                    onPressed: () {
                      final item = widget.item;
                      if (item != null) {
                        final shareText =
                            '${item.title}\n${item.subtitle}\n${item.imageUrl ?? ''}';
                        _shareDirect(context, shareText.trim());
                      }
                    },
                  ),
                ],
              ),
            ),
            // CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildDescription(subtitleText),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // IMAGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildImage(item.imageUrl),
            ),
            const SizedBox(height: 12),
            // ACTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Icon(Icons.favorite_border, color: Colors.pink),
                        Text('420'),
                        Icon(Icons.mode_comment_outlined, color: Colors.grey),
                        Text('120'),
                        Icon(Icons.share, color: Colors.grey),
                        Text('80 '),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.thumb_up_off_alt, color: Colors.grey),
                      SizedBox(width: 12),
                      Icon(Icons.chat_bubble_outline, color: Colors.grey),
                      SizedBox(width: 12),
                      Icon(Icons.share_outlined, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

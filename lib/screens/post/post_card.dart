/*
  Renders a post card with title, content (expand/collapse), image (network/file/placeholder),
  optional edit/delete actions, loading skeleton, and created-at display.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'delete_post.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String? postUserId;
  final String? title;
  final String? content;
  final String? imageUrl;
  final DateTime? createdAt;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;

  const PostCard({
    super.key,
    required this.postId,
    this.postUserId,
    this.title,
    this.content,
    this.imageUrl,
    this.createdAt,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;

  // ---------------- IMAGE ----------------
  Widget _buildImage() {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return Image.asset(
        'assets/images/images.png',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (widget.imageUrl!.startsWith('http')) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(widget.imageUrl!),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  // ---------------- CONTENT ----------------
  Widget _buildContent() {
    if (widget.content == null || widget.content!.isEmpty) {
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.content!,
            style: DefaultTextStyle.of(context).style,
          ),
          maxLines: 3,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final hasOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.content!,
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
            if (hasOverflow)
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
      },
    );
  }

  // ---------------- SKELETON ----------------
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _skeleton(width: 180),
        const SizedBox(height: 8),
        _skeleton(),
        const SizedBox(height: 6),
        _skeleton(width: 250),
        const SizedBox(height: 12),
        _skeleton(height: 200),
        const SizedBox(height: 8),
        _skeleton(width: 100),
      ],
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final canManage =
        currentUserId != null && currentUserId == widget.postUserId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: widget.isLoading
            ? _buildSkeleton()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + ACTIONS
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (canManage)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == 'edit') widget.onEdit?.call();
                            if (value == 'delete') {
                              await DeletePostService.deletePost(widget.postId);
                              if (widget.onDelete != null) widget.onDelete!();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post deleted')),
                                );
                              }
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // CONTENT
                  _buildContent(),

                  const SizedBox(height: 10),

                  // IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildImage(),
                  ),

                  const SizedBox(height: 6),

                  // DATE
                  if (widget.createdAt != null)
                    Text(
                      "${widget.createdAt!.toLocal()}".split(' ')[0],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
      ),
    );
  }
}

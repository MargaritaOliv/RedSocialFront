import 'package:flutter/material.dart';
import 'package:redsocial/feactures/post_detail/domain/entities/comment.dart';
import 'package:redsocial/theme/shapes.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  final List<Comment> comments;
  final Future<void> Function(String postId, String text) addCommentCallback;

  const CommentSection({
    super.key,
    required this.postId,
    required this.comments,
    required this.addCommentCallback,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);
    await widget.addCommentCallback(widget.postId, text);

    if (mounted) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentarios (${widget.comments.length})',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: AppShapes.inputBorderRadius,
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Añadir un comentario...',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: textTheme.bodyMedium,
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSubmitting ? null : _submitComment,
                  icon: _isSubmitting
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                      : Icon(
                    Icons.send,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (widget.comments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sé el primero en comentar',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.comments.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: colorScheme.outlineVariant,
              ),
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: colorScheme.secondaryContainer,
                        backgroundImage: comment.userAvatar != null &&
                            comment.userAvatar!.isNotEmpty
                            ? NetworkImage(comment.userAvatar!)
                            : null,
                        child: comment.userAvatar == null ||
                            comment.userAvatar!.isEmpty
                            ? Icon(
                          Icons.person_outline,
                          size: 20,
                          color: colorScheme.onSecondaryContainer,
                        )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.userName,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment.text,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
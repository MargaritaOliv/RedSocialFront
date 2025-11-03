// feactures/post_detail/presentation/widgets/comment_section.dart

import 'package:flutter/material.dart';
import 'package:redsocial/feactures/post_detail/domain/entities/comment.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';

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

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      widget.addCommentCallback(widget.postId, text);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comentarios (${widget.comments.length})', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          // Campo para añadir comentario
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _commentController,
                  label: '',
                  hint: 'Añadir un comentario...',
                  prefixIcon: Icons.comment_outlined,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                onPressed: _submitComment,
                child: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Lista de Comentarios
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text('Usuario ${comment.userId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(comment.text),
              );
            },
          ),
        ],
      ),
    );
  }
}
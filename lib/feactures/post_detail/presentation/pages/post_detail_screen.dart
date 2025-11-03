// feactures/post_detail/presentation/pages/post_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_button.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';
import '../providers/post_detail_notifier.dart';
import '../widgets/comment_section.dart'; // Widget de comentarios
import '../widgets/post_content.dart'; // Widget de contenido

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostDetailNotifier>().fetchPostDetail(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Publicación')),
      body: Consumer<PostDetailNotifier>(
        builder: (context, notifier, child) {
          switch (notifier.status) {
            case PostDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PostDetailStatus.error:
              return Center(child: Text('Error: ${notifier.errorMessage}'));

            case PostDetailStatus.loaded:
              if (notifier.post == null) {
                return const Center(child: Text('Publicación no encontrada.'));
              }
              return _buildContent(notifier);

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildContent(PostDetailNotifier notifier) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenido del Post
          PostContent(post: notifier.post!),

          // Barra de Acciones (Like, Comentar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    notifier.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: notifier.isLiked ? Colors.red : null,
                  ),
                  onPressed: () => notifier.toggleLike(widget.postId),
                ),
                Text('Likes (Simulado)'),
              ],
            ),
          ),
          const Divider(),

          // Sección de Comentarios
          CommentSection(
            postId: widget.postId,
            comments: notifier.comments,
            addCommentCallback: notifier.addComment,
          ),
        ],
      ),
    );
  }
}
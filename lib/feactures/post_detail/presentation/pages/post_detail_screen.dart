import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_detail_notifier.dart';
import '../widgets/comment_section.dart';
import '../widgets/post_content.dart';

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
      appBar: AppBar(title: const Text('Detalle de la Obra')),
      body: Consumer<PostDetailNotifier>(
        builder: (context, notifier, child) {
          switch (notifier.status) {
            case PostDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PostDetailStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${notifier.errorMessage}'),
                    ElevatedButton(
                      onPressed: () => notifier.fetchPostDetail(widget.postId),
                      child: const Text('Reintentar'),
                    )
                  ],
                ),
              );

            case PostDetailStatus.loaded:
              if (notifier.post == null) {
                return const Center(child: Text('Publicación no encontrada.'));
              }
              return _buildContent(notifier);

            default:
              return const SizedBox.shrink();
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
          PostContent(post: notifier.post!),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    notifier.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: notifier.isLiked ? Colors.red : null,
                    size: 30,
                  ),
                  onPressed: () => notifier.toggleLike(widget.postId),
                ),
                const Text('Me gusta'),
              ],
            ),
          ),
          const Divider(),

          CommentSection(
            postId: widget.postId,
            comments: notifier.comments,
            addCommentCallback: notifier.addComment,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
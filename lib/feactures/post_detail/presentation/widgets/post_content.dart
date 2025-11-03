// feactures/post_detail/presentation/widgets/post_content.dart

import 'package:flutter/material.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';

class PostContent extends StatelessWidget {
  final Posts post;
  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          // Simulación de imagen (si tu modelo de Posts la tuviera)
          // Container(height: 200, color: Colors.grey[300]),
          // const SizedBox(height: 12),
          Text(
            post.body,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
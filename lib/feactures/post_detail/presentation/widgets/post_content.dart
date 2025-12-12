import 'package:flutter/material.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import 'package:redsocial/theme/shapes.dart';

class PostContent extends StatelessWidget {
  final Posts post;
  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: post.authorPhoto != null
                    ? NetworkImage(post.authorPhoto!)
                    : null,
                child: post.authorPhoto == null
                    ? Icon(
                  Icons.person,
                  color: colorScheme.onPrimaryContainer,
                  size: 28,
                )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Publicado recientemente',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                },
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            post.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: AppShapes.cardBorderRadius,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
              ),
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No se pudo cargar la imagen',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            post.description,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
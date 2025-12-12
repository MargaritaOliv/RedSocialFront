import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redsocial/core/router/routes.dart'; // Importante para la ruta
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/theme/shapes.dart';

class ProfileHeader extends StatelessWidget {
  final int postCount;
  final User user;
  const ProfileHeader({super.key,
    required this.user, required this.postCount,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [

            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage:
                    user.avatar != null && user.avatar!.isNotEmpty
                        ? NetworkImage(user.avatar!)
                        : null,
                    child: user.avatar == null || user.avatar!.isEmpty
                        ? Icon(
                      Icons.person,
                      size: 60,
                      color: colorScheme.onPrimaryContainer,
                    )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              user.name,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  user.email,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (user.bio != null && user.bio!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: AppShapes.cardBorderRadius,
                ),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  label: 'Publicaciones',
                  value: postCount.toString(),
                  icon: Icons.article_outlined,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colorScheme.outlineVariant,
                ),
                _StatItem(
                  label: 'Seguidores',
                  value: user.followers.length.toString(),
                  icon: Icons.people_outline,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colorScheme.outlineVariant,
                ),
                _StatItem(
                  label: 'Siguiendo',
                  value: user.following.length.toString(),
                  icon: Icons.person_add_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24),


            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {

                      context.pushNamed(AppRoutes.editProfile);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar Perfil'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.outline),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppShapes.buttonBorderRadius,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Compartir'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppShapes.buttonBorderRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
// feactures/profile/presentation/widgets/profile_header.dart

import 'package:flutter/material.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen de Perfil
          CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            // Muestra imagen si existe, sino un icono
            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                ? NetworkImage(user.avatar!) as ImageProvider
                : null,
            child: user.avatar == null || user.avatar!.isEmpty
                ? Icon(Icons.person, size: 50, color: colorScheme.primary)
                : null,
          ),
          const SizedBox(height: 16),

          // Nombre de Usuario
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Email (opcionalmente)
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),

          // Biografía
          if (user.bio != null && user.bio!.isNotEmpty)
            Text(
              user.bio!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

          const SizedBox(height: 24),

          // Botón de Acción (Ej. Editar Perfil)
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navegar a pantalla de edición
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Perfil'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
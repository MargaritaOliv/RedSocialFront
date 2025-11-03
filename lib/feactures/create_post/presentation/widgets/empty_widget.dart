// feactures/create_post/presentation/widgets/empty_widget.dart
// Puedes eliminar este archivo si no se necesita.

import 'package:flutter/material.dart';

class UploadPlaceholder extends StatelessWidget {
  const UploadPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text('Haz clic para subir imagen o ingresa URL', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/core/router/routes.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_button.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';
// Importamos el notifier de Home para recargar la lista al volver
import 'package:redsocial/feactures/home/presentation/providers/posts_notifier.dart';
import '../providers/create_post_notifier.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreatePost() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = context.read<CreatePostNotifier>();

    // URL por defecto si el usuario no pone una (para pruebas)
    String finalImageUrl = _imageUrlController.text.trim();
    if (finalImageUrl.isEmpty) {
      finalImageUrl = 'https://via.placeholder.com/400x300.png?text=Sin+Imagen';
    }

    await notifier.createPost(
      title: _titleController.text.trim(),
      imageUrl: finalImageUrl,
      category: _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (mounted) {
      if (notifier.status == CreatePostStatus.success) {
        // 1. Mostrar éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Publicación creada con éxito!')),
        );

        // 2. Limpiar el estado del formulario
        notifier.clearStatus();

        // 3. Recargar el Home para que aparezca el nuevo post
        context.read<PostsNotifier>().fetchPosts();

        // 4. Volver al Home
        context.goNamed(AppRoutes.home);

      } else if (notifier.status == CreatePostStatus.error) {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notifier.errorMessage ?? 'Error desconocido'),
            backgroundColor: Colors.red,
          ),
        );
        notifier.clearStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Obra'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Consumer<CreatePostNotifier>(
            builder: (context, notifier, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _titleController,
                    label: 'Título de la Obra',
                    hint: 'Ej: Atardecer en la playa',
                    prefixIcon: Icons.title,
                    validator: (v) => v!.isEmpty ? 'Ingresa un título' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _imageUrlController,
                    label: 'URL de la Imagen',
                    hint: 'https://...',
                    prefixIcon: Icons.image_outlined,
                    keyboardType: TextInputType.url,
                    // Hacemos la validación opcional para facilitar pruebas
                    validator: (v) => null,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    ' * Si dejas la URL vacía, se usará una imagen de prueba.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _categoryController,
                    label: 'Categoría',
                    hint: 'Ej: Pintura, Digital',
                    prefixIcon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Descripción',
                    hint: 'Cuéntanos sobre tu obra...',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'Publicar',
                    onPressed: _handleCreatePost,
                    isLoading: notifier.status == CreatePostStatus.loading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_button.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';
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
    print('👆 [UI] Botón presionado');

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = context.read<CreatePostNotifier>();

    // Imagen por defecto si viene vacía
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

    if (!mounted) return;

    if (notifier.status == CreatePostStatus.success) {
      print('🎉 [UI] Éxito');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Publicación creada con éxito!')),
      );
      notifier.clearStatus();
      context.read<PostsNotifier>().fetchPosts(); // Recargar Home
      context.pop(); // Volver
    } else if (notifier.status == CreatePostStatus.error) {
      print('💀 [UI] Error: ${notifier.errorMessage}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.errorMessage ?? 'Error desconocido'),
          backgroundColor: Colors.red,
        ),
      );
      notifier.clearStatus();
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
                    hint: 'Ej: Atardecer',
                    prefixIcon: Icons.title,
                    validator: (v) => v!.isEmpty ? 'Ingresa un título' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _imageUrlController,
                    label: 'URL de la Imagen',
                    hint: 'https://...',
                    prefixIcon: Icons.image_outlined,
                    validator: (v) => null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _categoryController,
                    label: 'Categoría',
                    hint: 'Ej: Arte',
                    prefixIcon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Descripción',
                    hint: 'Descripción...',
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
// feactures/create_post/presentation/pages/create_post_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_button.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';
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

    await notifier.createPost(
      title: _titleController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (mounted) {
      if (notifier.status == CreatePostStatus.success) {
        // Muestra éxito y cierra la pantalla o navega a Home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Publicación creada con éxito!')),
        );
        // Aquí podrías usar GoRouter para navegar: context.pop();

      } else if (notifier.status == CreatePostStatus.error) {
        // Muestra error
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
        title: const Text('Crear Nueva Publicación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
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
                      hint: 'Mi Obra de Arte',
                      prefixIcon: Icons.title,
                      validator: (v) => v!.isEmpty ? 'Ingresa un título' : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _categoryController,
                      label: 'Categoría',
                      hint: 'Pintura, Fotografía, Digital...',
                      prefixIcon: Icons.category_outlined,
                      validator: (v) => v!.isEmpty ? 'Ingresa una categoría' : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _imageUrlController,
                      label: 'URL de la Imagen',
                      hint: 'https://urldemiimagen.com/arte.jpg',
                      prefixIcon: Icons.image_outlined,
                      keyboardType: TextInputType.url,
                      validator: (v) => v!.isEmpty ? 'Ingresa una URL' : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Descripción',
                      hint: 'Una breve descripción de tu obra.',
                      prefixIcon: Icons.description_outlined,
                      maxLines: 4,
                      validator: (v) => v!.isEmpty ? 'Ingresa una descripción' : null,
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      text: 'Publicar Obra',
                      onPressed: _handleCreatePost,
                      isLoading: notifier.status == CreatePostStatus.loading,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
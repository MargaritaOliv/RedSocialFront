import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_button.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';
import 'package:redsocial/feactures/profile/presentation/providers/profile_notifier.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _imageController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileNotifier>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _imageController = TextEditingController(text: user?.avatar ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await context.read<ProfileNotifier>().updateProfile(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      profilePic: _imageController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Nombre',
                hint: 'Tu nombre',
                prefixIcon: Icons.person,
                validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _bioController,
                label: 'Biografía',
                hint: 'Cuéntanos sobre ti',
                prefixIcon: Icons.info_outline,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _imageController,
                label: 'URL de Foto de Perfil',
                hint: 'https://...',
                prefixIcon: Icons.image,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Guardar Cambios',
                onPressed: _handleUpdate,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
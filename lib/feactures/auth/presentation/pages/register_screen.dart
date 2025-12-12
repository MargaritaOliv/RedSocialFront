import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_button.dart';
import 'package:redsocial/feactures/auth/presentation/widgets/custom_text_field.dart';
import '../providers/auth_notifier.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final authNotifier = context.read<AuthNotifier>();

    await authNotifier.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (authNotifier.status == AuthStateStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso. Por favor inicia sesión.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );


      context.pop();

    } else if (authNotifier.status == AuthStateStatus.error) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authNotifier.errorMessage ?? 'Error al registrarse'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Crear Cuenta',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Únete a nuestra comunidad creativa',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Nombre
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre completo',
                      hint: 'Tu nombre',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingresa tu nombre';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    CustomTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      hint: 'ejemplo@correo.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingresa tu correo';
                        if (!value.contains('@')) return 'Correo inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Ingresa una contraseña';
                        if (value.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    Consumer<AuthNotifier>(
                      builder: (context, authNotifier, child) {
                        return CustomButton(
                          text: 'Registrarse',
                          onPressed: _handleRegister,
                          isLoading: authNotifier.status == AuthStateStatus.loading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
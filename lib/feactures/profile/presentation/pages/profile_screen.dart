// feactures/profile/presentation/pages/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_notifier.dart';
import '../widgets/profile_header.dart'; // Usaremos un widget para el encabezado
import 'package:redsocial/feactures/home/presentation/widgets/post_card.dart'; // Reutilizamos PostCard

class ProfileScreen extends StatefulWidget {
  final String userId; // Parámetro del GoRouter
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Nota: Si userId es el mismo que el usuario logueado, se llama a fetchProfileData().
      // Si es otro usuario, necesitarías otro use case (fetchUserProfile(userId)).
      context.read<ProfileNotifier>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario ${widget.userId == 'me' ? '' : widget.userId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Llama a AuthNotifier para cerrar sesión
            },
          )
        ],
      ),
      body: Consumer<ProfileNotifier>(
        builder: (context, notifier, child) {
          switch (notifier.status) {
            case ProfileStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case ProfileStatus.error:
              return Center(child: Text('Error: ${notifier.errorMessage}'));

            case ProfileStatus.loaded:
              if (notifier.user == null) {
                return const Center(child: Text('No se encontraron datos de perfil.'));
              }
              return _buildProfileContent(notifier);

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(ProfileNotifier notifier) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ProfileHeader(user: notifier.user!),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'Mis Publicaciones (${notifier.posts.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        notifier.posts.isEmpty
            ? const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No has realizado ninguna publicación.'),
            ),
          ),
        )
            : SliverList.builder(
          itemCount: notifier.posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: notifier.posts[index]);
          },
        ),
      ],
    );
  }
}
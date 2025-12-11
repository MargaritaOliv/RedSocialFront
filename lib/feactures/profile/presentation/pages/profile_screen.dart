import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:redsocial/core/router/routes.dart';
import '../providers/profile_notifier.dart';
import 'package:redsocial/feactures/auth/presentation/providers/auth_notifier.dart';
import '../widgets/profile_header.dart';
import 'package:redsocial/feactures/home/presentation/widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileNotifier>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              context.read<AuthNotifier>().logout();
              context.goNamed(AppRoutes.login);
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${notifier.errorMessage}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: notifier.fetchProfileData,
                      child: const Text('Reintentar'),
                    )
                  ],
                ),
              );

            case ProfileStatus.loaded:
              if (notifier.user == null) {
                return const Center(child: Text('No se encontraron datos.'));
              }
              return RefreshIndicator(
                onRefresh: () => notifier.fetchProfileData(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text('Aún no has publicado nada.'),
                        ),
                      ),
                    )
                        : SliverList.builder(
                      itemCount: notifier.posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: notifier.posts[index]);
                      },
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
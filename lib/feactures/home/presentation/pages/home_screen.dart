// feactures/home/presentation/pages/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart'; // Correcto
import '../providers/posts_notifier.dart';
import '../widgets/post_card.dart'; // Correcto

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsNotifier>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Social Feed'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostsNotifier>().fetchPosts(),
          ),
          // TODO: Ejemplo de botón de Logout
        ],
      ),
      body: Consumer<PostsNotifier>(
        builder: (context, postsNotifier, child) {
          switch (postsNotifier.status) {
            case PostsStateStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case PostsStateStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    Text(
                      'Error al cargar posts: ${postsNotifier.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: postsNotifier.fetchPosts,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );

            case PostsStateStatus.loaded:
              return postsNotifier.posts.isEmpty
                  ? const Center(child: Text('No hay publicaciones para mostrar.'))
                  : _buildPostsList(postsNotifier.posts);

            case PostsStateStatus.initial:
            default:
              return const Center(child: Text('Cargando datos iniciales...'));
          }
        },
      ),
    );
  }

  Widget _buildPostsList(List<Posts> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(post: post);
      },
    );
  }
}
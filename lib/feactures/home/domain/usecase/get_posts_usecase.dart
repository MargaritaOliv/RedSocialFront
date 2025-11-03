// feactures/home/domain/usecase/get_posts_usecase.dart

import '../entities/posts.dart';
import '../repository/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository postsRepository;

  GetPostsUseCase(this.postsRepository);

  Future<List<Posts>> call() async {
    return await postsRepository.getPosts();
  }
}
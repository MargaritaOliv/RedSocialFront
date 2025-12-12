import '../entities/posts.dart';
import '../repository/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository postsRepository;

  GetPostsUseCase(this.postsRepository);

  Future<List<Posts>> call() async {
    return await postsRepository.getPosts();
  }
}
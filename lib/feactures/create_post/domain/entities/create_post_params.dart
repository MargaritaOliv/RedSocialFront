import 'package:equatable/equatable.dart';

class CreatePostParams extends Equatable {
  final String title;
  final String imageUrl;
  final String category;
  final String description;

  const CreatePostParams({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.description,
  });

  @override
  List<Object?> get props => [title, imageUrl, category, description];
}
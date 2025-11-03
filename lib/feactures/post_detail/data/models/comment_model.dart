// feactures/post_detail/data/models/comment_model.dart

import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  final String id;
  final String text;
  final String userId;
  final String postId;

  CommentModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.postId,
  }) : super(id: id, text: text, userId: userId, postId: postId);

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'].toString(),
      text: json['text'] ?? '',
      userId: json['userId'].toString(),
      postId: json['postId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
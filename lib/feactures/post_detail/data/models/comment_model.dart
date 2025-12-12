import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.text,
    required super.userId,
    required super.userName,
    super.userAvatar,
    required super.postId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final userObj = json['user'];
    String uId = '';
    String uName = 'Usuario';
    String? uAvatar;

    if (userObj is Map<String, dynamic>) {
      uId = userObj['_id']?.toString() ?? '';
      uName = userObj['name'] ?? 'Usuario';
      uAvatar = userObj['profilePic'];
    } else if (userObj is String) {
      uId = userObj;
    }

    return CommentModel(
      id: json['_id']?.toString() ?? '',
      text: json['text'] ?? '',
      userId: uId,
      userName: uName,
      userAvatar: uAvatar,
      postId: json['post']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
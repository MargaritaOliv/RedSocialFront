// feactures/post_detail/data/models/add_comment_request_model.dart

class AddCommentRequestModel {
  final String text;

  AddCommentRequestModel({required this.text});

  Map<String, dynamic> toJson() {
    return {'text': text};
  }
}
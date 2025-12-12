class AddCommentRequestModel {
  final String text;

  AddCommentRequestModel({required this.text});

  Map<String, dynamic> toJson() {
    return {'text': text};
  }
}
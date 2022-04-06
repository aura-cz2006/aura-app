import 'package:aura/models/user.dart';

class Comment {
  late String commentID;
  late String userID;
  late DateTime timestamp;
  late String? text;

  Comment(this.commentID, this.userID, this.timestamp, this.text);

  Comment.toBackEnd({required this.text});

// factory Comment.fromJson(Map<String>)
}
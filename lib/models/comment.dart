import 'package:aura/models/user.dart';

class Comment {
  String commentID;
  String userID;
  DateTime timestamp;
  String? text;

  Comment(this.commentID, this.userID, this.timestamp, this.text);
}
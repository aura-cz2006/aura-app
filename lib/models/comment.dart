import 'package:aura/models/user.dart';

class Comment {
  String ID;
  String userID;
  DateTime timestamp;
  String? text;

  Comment(this.ID, this.userID, this.timestamp, this.text);
}
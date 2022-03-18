import 'package:aura/models/user.dart';

class Comment {
  String ID;
  User author;
  DateTime timestamp;
  String? text;

  Comment(this.ID, this.author, this.timestamp, this.text);
}
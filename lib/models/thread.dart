import 'user.dart';
class Thread {
  String? id;
  String? title;

  String content;
  List<String> comments = []; // todo: change this to List<Comment>
  User author;
  List<User> likedBy = [];

  // constructor
  Thread(
      this.id,
      this.title,
      this.author,
      this.content// body, comments, author, likedBy
      );

  @override
  String toString() {
    return 'Discussion: {id: ${id ?? ""}, title: ${title ?? ""}}';
  }
}
import 'package:aura/models/comment.dart';

import 'user.dart';
class Thread {
  String? id;
  String? title;

  String content;
  List<Comment> comments = [];
  User author;
  List<User> likedBy = [];
  DateTime timestamp;

  // constructor
  Thread(
      this.id,
      this.title,
      this.author,
      this.content,
      this.timestamp// comments, likedBy
      ) ;

  @override
  String toString() { //todo
    return 'Thread: {id: ${id ?? ""}, title: ${title ?? ""}}';
  }
  void addComment(Comment newC) {
    comments.add(newC);
  }
  bool isLikedBy(User user) {
    if (likedBy.contains(user)) {
      return true;
    }
    else {
      return false;
    }
  }
  void addLike(User user) {
    likedBy.add(user);
  }
  void removeLike(User user) {
    likedBy.remove(user);
  }
  int numLikes() { // TODO REMOVE THIS DUMMY CODE
    if (this.id == '1') {
      return likedBy.length + 1;
    }
    else {
      return likedBy.length + 99;
    }
    return likedBy.length; // TODO PUT THIS BACK
  }
}
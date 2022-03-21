import 'package:aura/models/comment.dart';

import 'user.dart';

class Thread {
  String id;
  String? title;
  String userID;
  String content;
  String topic;
  DateTime timestamp;
  List<Comment> comments = [];
  List<String> likedBy = []; // list of userIDs

  // constructor
  Thread(
    this.id,
    this.title,
    this.userID,
    this.content,
    this.topic,
    this.timestamp,
  );

  @override
  String toString() {
    //todo remove this ???
    return 'Thread: {id: ${id ?? ""}, title: ${title ?? ""}}';
  }

  void addComment(String userID, String text) {
    Comment newC = Comment('commentID', userID, DateTime.now(), text); // todo set up unique comment id
    comments.add(newC);
  }

  void removeComment(String commentID) {
    Comment comment = comments.firstWhere((c) => c.ID == commentID);
    comments.remove(comment);
  }

  bool isLikedBy(String userID) {
    if (likedBy.indexWhere((uID) => uID == userID) == -1) {
      return false; // not found
    }
    return true;
  }

  void addLike(String userID) {
    likedBy.add(userID);
  }

  void removeLike(String userID) {
    likedBy.remove(userID);
  }

  int numLikes() {
    // TODO REMOVE THIS DUMMY CODE
    if (this.id == '1') {
      return likedBy.length + 1;
    } else {
      return likedBy.length + 99;
    }
    return likedBy.length; // TODO PUT THIS BACK
  }
}

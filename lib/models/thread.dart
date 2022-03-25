import 'package:aura/models/comment.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:intl/intl.dart';


class Thread {
  String id;
  String? title;
  String userID;
  String content;
  DiscussionTopic topic;
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
    return 'Thread: {id: $id, title: ${title ?? ""}}';
  }

  void addComment(String userID, String text) {
    Comment newC = Comment('commentID', userID, DateTime.now(),
        text); // todo set up unique comment id
    comments.add(newC);
  }

  void removeComment(String commentID) {
    Comment comment = comments.firstWhere((c) => c.commentID == commentID);
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
    return likedBy.length;
  }

  String getSummary() {
    return "[${topic.topic2readable()}] $title \nPosted on: ${DateFormat('yyyy-MM-dd kk:mm').format(timestamp)}";
  }
}

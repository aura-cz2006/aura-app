import 'package:aura/models/comment.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:intl/intl.dart';


class Thread {
  late String id;
  late String? title;
  late String userID;
  late String content;
  late DiscussionTopic topic;
  late DateTime timestamp;
  late List<Comment> comments = [];
  late List<String> likedBy = []; // list of userIDs

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

  static List<Comment> constructCommentsListfromStringList(List<dynamic> jsonInputListOfMap){
    List<Comment> result = [];

    for (dynamic item in jsonInputListOfMap){

      Comment commentToAdd = Comment(item['id']!, item['user']!,
          DateTime.parse(item['timestamp']!), item['text']);
      result.add(commentToAdd);
    }
    return result;
  }

  factory Thread.getFromJson(Map<String, dynamic> json){

    return Thread.fromBackEnd(json['id'], json['title'], json['userID'],
        json['content'], TopicConverter.parsable2topic(json['topic']),
        DateTime.parse(json['date']), constructCommentsListfromStringList(json['comments']),   List<String>.from(json['likedBy']));
  }
}

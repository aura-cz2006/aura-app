import 'package:aura/models/comment.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Thread {
  late String id;
  late String? title;
  late String userID;
  late String content;
  late DiscussionTopic topic;
  late DateTime timestamp;
  late List<Comment> comments = [];
  late List<String> likedBy = []; // list of userIDs
  late String displayName;

  // constructor for app
  Thread(
      this.id,
      this.title,
      this.userID,
      this.content,
      this.topic,
      this.timestamp,
      );
  //Constructor for backend
  Thread.fromBackEnd({
    required this.id,
    required this.title,
    required this.userID,
    required this.displayName,
    required this.content,
    required this.topic,
    required this.timestamp,
    required this.comments,
    required this.likedBy
    }
  );

  // id: json['id'].toString(),
  // title: json['title'],
  // userID: json['author_user_id'],
  // content: json['content'],
  // topic: TopicConverter.parsable2topic(json['topic']),
  // timestamp: DateTime.parse(json['date']),
  // comments: comments, //constructCommentsListfromStringList(json['comments'])
  // likedBy: likes, //List<String>.from(json['likedBy'])

  /*
  For debugging purposes
   */
  @override
  String toString() {
    return 'Thread: {id: $id, title: ${title ?? ""}, userID: ${userID}, displayName: ${displayName}, content: ${content}, topic: ${topic}, timestamp: ${timestamp}, comments: ${comments}, likes: ${likedBy}';
  }

  void addComment(String userID, String text) {
    Comment newC = Comment('commentID', userID, DateTime.now(),
        text);
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
    
    if (jsonInputListOfMap.isEmpty || jsonInputListOfMap == null){return result;}
    
    for (dynamic item in jsonInputListOfMap){
      Comment commentToAdd = Comment(item['id']!, item['user']!,
          DateTime.parse(item['timestamp']!), item['text']);
      result.add(commentToAdd);
    }
    return result;
  }

  factory Thread.getFromJson(Map<String, dynamic> json){
    List<Comment> comments = [];
    List<String> likes = [];
    //json['id'], json['title'], json['userID'],
    //         json['content'], TopicConverter.parsable2topic(json['topic']),
    //         DateTime.parse(json['date']), comments,   List<String>.from(json['likedBy'])
    print("id: ${json['id'].toString()}");
    print("title: ${json['title']}, runtype: ${json['title'].runtimeType}");
    print("author_user_id: ${json['author_user_id']}");
    print("content: ${json['content']}, runtype:  ${json['content'].runtimeType}");
    print("Fetching Thread. Topic: ${TopicConverter.parsable2topic(json['topic'])}, runtype = ${TopicConverter.parsable2topic(json['topic']).runtimeType} ");
    print("Comment: ${comments}, runtype = ${comments.runtimeType}");

    Thread thread = Thread.fromBackEnd(
        id: json['id'].toString(),
        title: json['title'],
        userID: json['author']['id'],
        displayName: json['author']['displayName'],
        content: json['content'],
        topic: TopicConverter.parsable2topic(json['topic']),
        timestamp: DateTime.parse(json['date']),
        comments: comments, //constructCommentsListfromStringList(json['comments'])
        likedBy: likes, //List<String>.from(json['likedBy'])
    );
    print("${thread}");
    print("Exiting======");

    return thread;
  }
}


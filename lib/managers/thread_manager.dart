import 'package:aura/models/comment.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:aura/util/manager.dart';

class Thread_Manager extends Manager {
  var thread_list = [
  ];

  void updateThreadList(List<Thread> threadList){
    thread_list = threadList;
  }

  List<Thread> getListOfThreadsSortedByLikes(DiscussionTopic topic) {
    var curr_list = getThreadsByTopic(topic);
    curr_list.sort((a, b) => b.numLikes().compareTo(a.numLikes()));
    return curr_list;
  } //

  List<Thread> getListOfThreadsSortedByTime(DiscussionTopic topic) {
    var curr_list = getThreadsByTopic(topic);
    curr_list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return curr_list;
  }

  List<Thread> getThreadsByTopic(DiscussionTopic topic) {
    List<Thread> filtered_thread_list = [];
    for (var each in thread_list) {
      if (each.topic == topic) {
        filtered_thread_list.add(each);
      }
    }
    return filtered_thread_list;
  }

  Thread? getThreadByID(String thread_id) {
    for (var each in thread_list) {
      if (each.id == thread_id) return each;
    }
  }

  List<Comment> getCommentsForThread(String thread_id) {
    return getThreadByID(thread_id)!.comments;
  }

  void editThread(String thread_id, String new_title, String new_content) {
    var threadforEdit = getThreadByID(thread_id);
    threadforEdit!.title = new_title;
    threadforEdit.content = new_content;
    notifyListeners();
  }

  void removeLike(String threadID, String userID) {
    Thread thread = getThreadByID(threadID)!;
    thread.removeLike(userID);
    notifyListeners();
  }

  void addLike(String threadID, String userID) {
    Thread thread = getThreadByID(threadID)!;
    thread.addLike(userID);
    notifyListeners();
  }

  void addComment(String threadID, String userID, String text) {
    Thread thread = getThreadByID(threadID)!;
    thread.addComment(userID, text);
    notifyListeners();
  }

  void removeComment(String threadID, String commentID) {
    Thread thread = getThreadByID(threadID)!;
    thread.removeComment(commentID);
    notifyListeners();
  }

  bool isLikedBy(String threadID, String userID) {
    Thread thread = getThreadByID(threadID)!;
    return thread.isLikedBy(userID);
  }

  int getNumLikes(String threadID) {
    Thread thread = getThreadByID(threadID)!;
    return thread.numLikes();
  }

  static String generateUniqThreadID(){
    return (10).toString(); //TODO: we need to change this
  }

  void removeThread(String threadID) {
    thread_list.remove(getThreadByID(threadID));
    notifyListeners();
  }
}

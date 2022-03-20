import 'package:aura/models/comment.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/util/manager.dart';

class Thread_Manager extends Manager {
  var thread_list = [
    Thread('1', 'Otters spotted at Marina Bay Sands!', '2',
        'what a rare sight!', "Nature", DateTime.now()),
    Thread(
        '2',
        'Rafflesia spotted at Raffles City',
        '4',
        'what a gorgeous specimen! \nI love plants! \nBotanics is my favourite hobby, I could go on and on about it for days \nIn short, I love plants!',
        "Nature",
        DateTime.now().add(const Duration(days: 2))),
    Thread(
        '3',
        'Delicious Japanese food at Ion Orchard',
        '1',
        'Yummy and affordable',
        "Food",
        DateTime.now()),
    Thread('4', 'New SSD out on the market!', '3',
        'so much memory at such an affordable price!', "IT", DateTime.now()),
    Thread('5', 'New Muay Thai facility in NTU', '5',
        'Time to beat some people', "Sports", DateTime.now()),
    Thread(
        '6',
        'Attack on Titan Exhibition at Art Science Museum!',
        '6',
        'Rumbling, rumbling, it\'s coming!',
        "General Discussion",
        DateTime.now())
  ];

  List<Thread> getListOfThreadsSortedByLikes(String topic) {
    var curr_list = getThreadsByTopic(topic);
    curr_list.sort((a, b) => b.numLikes().compareTo(a.numLikes()));
    return curr_list;
  }//TODO: Figure this out

  List<Thread> getListOfThreadsSortedByTime(String topic) {
    var curr_list = getThreadsByTopic(topic);
    curr_list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return curr_list;
  }

  List<Thread> getThreadsByTopic(String topic) {
    List<Thread> filtered_thread_list = [];
    for (var each in thread_list){
      if (each.topic == topic){
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

  void addThread(String title, String content, String topic, String UserID){
    thread_list.add(Thread('1', title, UserID, content, topic, DateTime.now()));
    notifyListeners();
  }

  void removeThread(String threadID){
    thread_list.remove(getThreadByID(threadID));
    notifyListeners();
  }
}

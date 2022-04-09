import 'package:aura/apis/discussion_api.dart';
import 'package:aura/managers/thread_manager.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/view/community/create_thread_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ThreadController {
  static Future<void> fetchThreads(BuildContext context) async {

    // call api (convert to dart there) and receive api data
    List<Thread> fetchedThreadItems = await DiscussionThreadApi.fetchTopicThreads();
    // call provider
    Provider.of<Thread_Manager>(context, listen: false).updateThreadList(
        fetchedThreadItems
    );
    print("==========================EXITING THREAD CONTROLLER=============================");
  }

  static Future<int> createThread(
      {required String title, required String content, required DiscussionTopic topic, required String userID}) {
    Thread threadtoAdd = Thread('placeholderID', title, userID, content, topic, DateTime.now());
    return DiscussionThreadApi.postThread(thread: threadtoAdd);
  }

  static Future<int> patchThread({required Thread thread, required String title, required String content}){
    return DiscussionThreadApi.patchThread(thread: thread, title: title, content: content);
  }

  static Future<int> deleteThread({required Thread thread}){
    return DiscussionThreadApi.deleteThread(thread: thread);
  }
}
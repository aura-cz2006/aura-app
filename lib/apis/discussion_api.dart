import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:aura/config/config.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';

class DiscussionThreadApi {
  static Future<List<Thread>> fetchTopicThreads() async {
    print("================ENTERED THREAD API====================");
    Uri url = Uri.parse("${Config().routes["api"]}/discussions/");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;

      // use dart:convert to decode JSON
      List<dynamic> decodedJson =
      json.decode(responseBody);

      List<Thread> resList = (decodedJson).map((item) {
        return Thread.getFromJson(item);
      }).toList();
      print("List: ${resList}");
      return resList;
    } else {
      print(
          "ERROR fetching Threads: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }

  static Future<int> postThread({required Thread thread}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/discussions/${thread.topic.topic2parsable()}/threads");

    var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    print(token);

    print("Posting Thread. Topic: ${thread.topic.topic2parsable()}");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer ${token}"
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          'title': thread.title!,
          "userID": thread.userID,
          "content": thread.content,
          "topic": thread.topic.topic2parsable(), //DiscussionTopic
          "timestamp": thread.timestamp.toString(),
        });

    return response.statusCode; //200 == Success, 400 == Failure.
  }

  static Future<int> patchThread({required Thread thread, required String title, required String content}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/discussions/${thread.topic.topic2parsable()}/threads/${thread.id}");
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer ${token}"
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        'title': title,
        "content": content,
      },
    );

    return response.statusCode;
  }

  static Future<int> deleteThread({required Thread thread}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/discussions/${thread.topic.topic2parsable()}/threads/${thread.id}");
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer ${token}"
      },
      encoding: Encoding.getByName('utf-8'),
    );

    return response.statusCode;
  }
}

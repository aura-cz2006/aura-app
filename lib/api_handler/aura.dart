// discussion apis

import 'package:aura/models/thread.dart';
// import 'package:dio/dio.dart';

class AuraDiscussionAPI {
  static Future<List<Thread>> getDiscussions() async {
    // todo: call API with dio.get()
    // String apiUrl = "https://aura-app.com/discussions";

    // Response response = await Dio().get(apiUrl);

    return [
      Thread("1234", "title")
    ];
  }
}

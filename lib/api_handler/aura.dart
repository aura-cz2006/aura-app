// discussion apis

import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
// import 'package:dio/dio.dart';

class AuraDiscussionAPI {
  static Future<List<Thread>> getDiscussions() async {
    // todo: call API with dio.get()
    // String apiUrl = "https://aura-app.com/discussions";

    // Response response = await Dio().get(apiUrl);

    return [
      Thread("0000", "TEST THREAD TITLE", "01",
          "this is some content", "Anime", DateTime.now())
    ];
  }
}

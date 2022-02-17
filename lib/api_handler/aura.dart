// discussion apis

import 'package:aura/models/discussion.dart';
// import 'package:dio/dio.dart';

class AuraDiscussionAPI {
  static Future<List<Discussion>> getDiscussions() async {
    // todo: call API with dio.get()
    // String apiUrl = "https://aura-app.com/discussions";

    // Response response = await Dio().get(apiUrl);

    return [
      Discussion("1234", "title")
    ];
  }
}

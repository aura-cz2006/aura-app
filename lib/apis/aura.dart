// discussion apis

import 'package:aura/models/discussion.dart';

class AuraDiscussionAPIInterface {
  static List<Discussion> getDiscussions() {
    // todo: call API with dio.get()
    return [
      Discussion("1234", "title")
    ];
  }
}

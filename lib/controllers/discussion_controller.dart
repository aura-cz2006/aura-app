import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/api_handler/aura.dart';
import 'package:aura/models/user.dart';

class DiscussionController {
  static void getDiscussions() async {
    DiscussionManager().setUpdating(true);

    List<Thread> discussions = await AuraDiscussionAPI.getDiscussions();

    DiscussionManager().setDiscussions(discussions);

    DiscussionManager().setUpdating(false);
  }

  static Thread getThread(String ID) {
    // TODO: get the list of threads from manager and return the thread with the matching ID
    return Thread("0000", "TEST THREAD TITLE", User("01", "khong"),
        "this is some content", DateTime.now());
  }
}

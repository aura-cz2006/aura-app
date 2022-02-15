import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/models/discussion.dart';
import 'package:aura/api_handler/aura.dart';

class DiscussionController {
  static void getDiscussions() async {
    DiscussionManager().setUpdating(true);

    List<Discussion> discussions =
        await AuraDiscussionAPI.getDiscussions();

    DiscussionManager().setDiscussions(discussions);

    DiscussionManager().setUpdating(false);
  }
}
import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/util/controller.dart';

class DiscussionController extends Controller {
  static void getDiscussions() {
    DiscussionManager().getDiscussions();
  }
}
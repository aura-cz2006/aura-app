import 'dart:collection';

import 'package:aura/apis/aura.dart';
import 'package:aura/models/discussion.dart';
import 'package:aura/util/manager.dart';

class DiscussionManager extends Manager {
  // internal private state of discussions
  final List<Discussion> _discussions = [
    Discussion("12345", "title0")
  ];

  // immutable list of discussions, to be consumed externally
  UnmodifiableListView<Discussion> get discussions =>
      UnmodifiableListView(_discussions);

  // methodssync {
  // call API
  void getDiscussions() async {
    // call API

    List<Discussion> newDiscussions =
        await AuraDiscussionAPIInterface.getDiscussions();
    newDiscussions.forEach((element) {print(element.toString());});
    print(_discussions.length);

    _discussions.addAll(newDiscussions);
    // store API result in state
    notifyListeners();
  }

  void createDiscussion() {
    // call API
    getDiscussions(); // update local state and notify listeners
  }
}

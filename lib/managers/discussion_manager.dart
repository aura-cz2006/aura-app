import 'dart:collection';
import 'package:aura/models/thread.dart';
import 'package:aura/util/manager.dart';

class DiscussionManager extends Manager {
  // internal private state of discussions
  final List<Thread> _discussions = [
    // Discussion("12345", "title0")
  ];
  bool _isUpdating = false;

  // immutable list of discussions, to be consumed externally
  bool get isUpdating => _isUpdating; // todo: fix this

  UnmodifiableListView<Thread> get discussions =>
      UnmodifiableListView(_discussions);

  void setUpdating(bool newVal) {
    _isUpdating = newVal;
  }

  void setDiscussions(List<Thread> discussions) {
    // discussions.forEach((element) {print(element.toString());});
    // print(_discussions.length);

    _discussions.addAll(discussions);
    // store API result in stat
    notifyListeners();
  }

  void addDiscussion() {
    // call API
    // ? return http status?
    notifyListeners();
  }
}

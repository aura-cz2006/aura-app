import 'dart:collection';

import 'package:aura/models/notification.dart';
import 'package:aura/util/manager.dart';

class NotificationManager extends Manager {
  // internal private state of notifications
  List<Notification> _notifications = [
    // dummy state
    ThreadNotification("1", ThreadNotifType.NEW_LIKE, true, "n04"),
    ThreadNotification("2", ThreadNotifType.NEW_COMMENT, false, "n03"),
    MeetupNotification("3", MeetupNotifType.REMINDER, true, "n02"),
    MeetupNotification("4", MeetupNotifType.SUCCESSFULLY_RSVP, false, "n01")
  ]; // TODO: get notifications from api

  bool _isUpdating = false;

  // immutable list of notifications, to be consumed externally
  bool get isUpdating => _isUpdating;

  UnmodifiableListView<Notification> get notifications =>
      UnmodifiableListView(_notifications);

  void setUpdating(bool newVal) {
    _isUpdating = newVal;
  }

  void setNotifications(List<Notification> notifications) {
    _notifications.addAll(notifications);
    notifyListeners();
  }

  void setNotificationReadStatus(String notifID, bool newReadStatus) {
    _notifications
        .firstWhere((n) => n.notifID == notifID)
        .setRead(newReadStatus);
    notifyListeners();
  }

  int getNumUnreadNotifications() {
    return _notifications.where((n) => n.isRead == false).toList().length;
  }
}

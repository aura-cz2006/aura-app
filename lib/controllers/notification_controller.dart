import 'package:aura/models/notification.dart';
import '../managers/notification_manager.dart';

class NotificationController {
  static void fetchNotifications() async {
    // NotificationManager().setUpdating(true);
  }

  static void setRead(String notifID, bool readStatus) { // ! deprecated - should be removed
    NotificationManager().setNotificationReadStatus(notifID, readStatus);
  }
}

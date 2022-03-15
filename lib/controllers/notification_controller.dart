import 'package:aura/models/notification.dart';
import '../managers/notification_manager.dart';

class NotificationController {
  static void fetchNotifications() async {
    // NotificationManager().setUpdating(true);
    // todo: handle api call here
  }

  static void setRead(String notifID, bool readStatus) {
    NotificationManager().updateNotificationReadStatus(notifID, readStatus);
  }
}

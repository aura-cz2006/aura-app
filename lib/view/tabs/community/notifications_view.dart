import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/notification_manager.dart';
import 'package:aura/managers/thread_manager.dart';
import 'package:aura/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class NotificationsView extends StatefulWidget {
  final String currUserID;

  const NotificationsView({Key? key, required this.currUserID})
      : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text('Notifications'),
      ),
      body: Consumer3<NotificationManager, Thread_Manager, Meetup_Manager>(
          builder: (context, notifMgr, threadMgr, meetupMgr, child) {
        return ListView(
            children: notifMgr.notifications
                .map((n) => ListTile(
                      title: Text(
                        n.getTypeMsg(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text((n is ThreadNotification) // todo fix
                          ? threadMgr.getThreadByID(n.threadID)!.getSummary()
                          : (n is MeetupNotification)
                              ? meetupMgr.getMeetupByID(n.meetupID).getSummary()
                              : ""),
                      leading: Icon(
                        n.isRead ? null : Icons.circle,
                        color: n.isRead ? null : Colors.red,
                        size: 15,
                      ),
                      onTap: () {
                        notifMgr.setNotificationReadStatus(n.notifID, true);
                        if (n is ThreadNotification) {
                          context.push("/tabs/community/thread/${n.threadID}");
                        } else if (n is MeetupNotification) {
                          context.push("/tabs/community/meetup/${n.meetupID}");
                        }
                      },
                    ))
                .toList());
      }),
    );
  }
}

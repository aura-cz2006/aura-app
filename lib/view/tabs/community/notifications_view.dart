import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/notification_manager.dart';
import 'package:aura/managers/thread_manager.dart';
import 'package:aura/models/notification.dart';
import 'package:aura/view/community/detailed_meetup_view.dart';
import 'package:aura/view/community/detailed_thread_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                          // TODO ROUTING: replace with go_router
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedThreadView(
                                      threadID: n.threadID,
                                      currUserID: widget.currUserID)));
                        } else if (n is MeetupNotification) {
                          // TODO: replace with go_router
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedMeetupView(
                                      meetupID: n.meetupID,
                                      currUserID: widget.currUserID)));
                        }
                      },
                    ))
                .toList());
      }),
    );
  }
}

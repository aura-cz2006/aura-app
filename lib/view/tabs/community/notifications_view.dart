import 'package:aura/controllers/discussion_controller.dart';
import 'package:aura/controllers/meetups_controller.dart';
import 'package:aura/controllers/notification_controller.dart';
import 'package:aura/managers/notification_manager.dart';
import 'package:aura/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detailed_meetup_view.dart';
import 'detailed_thread_view.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

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
      body: Consumer<NotificationManager>(
          builder: (context, notificationData, child) {
        return ListView(
            children: notificationData.notifications
                .map((n) => ListTile(
                      title: Text((n is ThreadNotification)
                          ? n.getText()
                          : (n is MeetupNotification)
                              ? n.getText()
                              : ""),
                      leading: Icon(
                        n.read ? null : Icons.circle,
                        color: n.read ? null : Colors.red,
                        size: 15,
                      ),
                      onTap: () {
                        NotificationController.setRead(
                            n.id, true); // TODO: switch to controller call?
                        if (n is ThreadNotification) {
                          // TODO: replace with go_router
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedThreadView(
                                      DiscussionController.getThread(
                                          n.threadID))));
                        } else if (n is MeetupNotification) {
                          // TODO: replace with go_router
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedMeetupView(
                                      MeetupsController.getMeetup(
                                          n.meetupID))));
                        }
                      },
                    ))
                .toList());
      }),
    );
  }
}

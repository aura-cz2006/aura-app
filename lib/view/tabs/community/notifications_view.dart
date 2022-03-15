import 'package:aura/controllers/meetups_controller.dart';
import 'package:aura/controllers/notification_controller.dart';
import 'package:aura/managers/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/discussion_controller.dart';
import '../../models/notification.dart' as no;
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
                      title: Text((n is no.ThreadNotification)
                          ? n.getText()
                          : (n is no.MeetupNotification)
                              ? n.getText()
                              : ""),
                      leading: Icon(
                        n.read ? null : Icons.circle,
                        color: n.read ? null : Colors.red,
                        size: 15,
                      ),
                      onTap: () {
                        NotificationController.setRead(n.id, true); // TODO: switch to controller call?
                        if (n is no.ThreadNotification) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedThreadView(
                                      DiscussionController.getThread(
                                          n.threadID))));
                        } else if (n is no.MeetupNotification) {
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

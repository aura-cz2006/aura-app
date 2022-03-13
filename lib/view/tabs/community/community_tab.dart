import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';

import 'package:aura/controllers/discussion_controller.dart';
import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/models/notification.dart' as no;
import '../../controllers/meetups_controller.dart';
import 'detailed_thread_view.dart';
import 'detailed_meetup_view.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  DiscussionController discCtrl = DiscussionController();
  MeetupsController meetCtrl = MeetupsController();
  List<no.Notification> notifications = [
    no.ThreadNotification("001", no.ThreadNotifType.NEW_LIKE, true),
    no.ThreadNotification.withoutRead("002", no.ThreadNotifType.NEW_COMMENT),
    no.MeetupNotification("003", no.MeetupNotifType.REMINDER, true),
    no.MeetupNotification.withoutRead("004", no.MeetupNotifType.SUCCESSFULLY_RSVP),
  ]; // TODO: get notifications from controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconBadge(
            icon: const Icon(Icons.notifications),
            itemCount: notifications.where((n) => n.read == false).toList().length,
            badgeColor: Colors.red,
            itemColor: Colors.white,
            hideZero: true,
            onTap: _displayNotifs
          ),
        ],
      ),
      body: Center(child: Consumer<DiscussionManager>(
          builder: (context, discussionManager, child) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: discussionManager.discussions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      margin: const EdgeInsets.all(2),
                      child: Center(
                          child: Text(
                        discussionManager.discussions[index].title ?? "undefined",
                        style: const TextStyle(fontSize: 18),
                      )),
                    );
                  });
            })),
    );
  }
  void _displayNotifs() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            final tiles = notifications.map(
                  (n) {
                return ListTile(
                  title: Text(
                      (n is no.ThreadNotification) ? n.getText(discCtrl) :
                        (n is no.MeetupNotification) ? n.getText(meetCtrl) : ""
                  ),
                  leading: Icon(
                    n.read ? null : Icons.circle,
                    color: n.read ? null : Colors.red,
                    size: 15,
                  ),
                  onTap: () {
                    setState(() {
                      n.markRead(); // TODO: need to fix, mark as read and remove red circle after tapping
                      if (n is no.ThreadNotification) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DetailedThreadView(
                                discCtrl.getThread(n.threadID))));
                      }
                      else if (n is no.MeetupNotification) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DetailedMeetupView(
                                meetCtrl.getMeetup(n.meetupID))));
                      }
                    });
                  },
                );
              },
            );
            final divided = tiles.isNotEmpty
                ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList()
                : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                title: const Text('Notifications'),
              ),
              body: ListView(children: divided),
            );
          },
    )
    );
  }
}

import 'package:aura/managers/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';

import 'package:aura/managers/discussion_manager.dart';

import 'notifications_view.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          Consumer<NotificationManager>(
              builder: (context, notifMgr, child) {
            return IconBadge(
              icon: const Icon(Icons.notifications),
              itemCount: notifMgr.getNumUnreadNotifications(),
              badgeColor: Colors.red,
              itemColor: Colors.white,
              hideZero: true,
              onTap: () => Navigator.push( // TODO ROUTING: replace w go router to notif view
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsView())),
            );
          })
        ],
      ),
      body: Center(child: Consumer<DiscussionManager>(
          builder: (context, discussionManager, child) {
        return Wrap(
          direction: Axis.vertical,
          spacing: 20,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push("${GoRouter.of(context).location}/topic/1234");
              },
              child: Text('some topic title'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push("${GoRouter.of(context).location}/meetups");
              },
              child: Text('Meetups'),
            ),
          ],
        );
        // ListView.builder(
        //   padding: const EdgeInsets.all(8),
        //   itemCount: discussionManager.discussions.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     // return Container(
        //     //     height: 50,
        //     //     margin: const EdgeInsets.all(2),
        //     //     child:
        //         // Center(
        //         //     child: Text(
        //         //       discussionManager.discussions[index].title ??
        //         //           "undefined",
        //         //       style: const TextStyle(fontSize: 18),
        //         //     )),
        //         // );
        //   });
      })),
    );
  }
}

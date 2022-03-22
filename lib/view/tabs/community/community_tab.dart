import 'package:aura/managers/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:aura/managers/discussion_manager.dart';


class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  // final String _testUserID = "1"; // TODO READ USER ID OF VIEWER FROM SOMEWHERE?

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
              onTap: () => context.push("/tabs/community/notifications")
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
                context.push("${GoRouter.of(context).location}/topic/nature");
              },
              child: const Text('some topic title'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push("${GoRouter.of(context).location}/meetups");
              },
              child: const Text('Meetups'),
            ),
          ],
        );
      })),
    );
  }
}

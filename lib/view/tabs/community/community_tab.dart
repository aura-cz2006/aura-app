import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';

import 'package:aura/managers/discussion_manager.dart';
import 'package:aura/models/notification.dart' as no;

import 'notifications_view.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  List<no.Notification> notifications = [
  ]; // TODO: get notifications from controller

  void _tapNotifs() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NotificationsView())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          Consumer<NotificationManager>(
              builder: (context, notificationData, child) {
                return IconBadge(
                    icon: const Icon(Icons.notifications),
                    itemCount: notificationData.notifications
                        .where((n) => n.read == false)
                        .toList()
                        .length,
                    badgeColor: Colors.red,
                    itemColor: Colors.white,
                    hideZero: true,
                    onTap: _tapNotifs
                );
              })
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
}

import 'package:aura/managers/notification_manager.dart';
import 'package:aura/models/notification.dart' as no;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:aura/managers/discussion_manager.dart';

Map<String, Map<String, dynamic>> topics = {
  "general": {
    "bgImage": "assets/General_discussion_topics.jpg",
    "name": "General Discussion",
  },
  "food": {
    "bgImage": "assets/topics_food.jpg",
    "name": "Food",
  },
  "tech": {
    "bgImage": "assets/IT_topics.jpg",
    "name": "IT",
  },
  "sports": {
    "bgImage": "assets/Sports_topic.webp",
    "name": "Sports",
  },
  "nature": {
    "bgImage": "assets/Nature_topic.jpeg",
    "name": "Nature",
  }
};

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  List<no.Notification> notifications =
      []; // TODO: get notifications from controller

  void _tapNotifs() {
    context.push("tabs/community/notifications");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          Consumer<NotificationManager>(
              builder: (context, notificationData, child) => Badge(
                    position: BadgePosition.topEnd(top: 8, end: 3),
                    badgeContent: Text(
                      notificationData.getNumUnreadNotifications().toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () =>
                          context.push("/tabs/community/notifications"),
                    ),
                  )),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black54,
            ),
            onPressed: () {
              GoRouter.of(context).push("/settings");
            },
          )
        ],
      ),
      body: Center(child: Consumer<DiscussionManager>(
          builder: (context, discussionManager, child) {
        return ListView(
          children: topics.entries
              .map<Widget>((entry) => Card(
                    child: InkWell(
                        onTap: () {
                          context.push(
                              "/tabs/community/topic/${(entry.value['name'] as String).toLowerCase()}");
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          height: 200,
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(entry.value['bgImage']),
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.darken),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                          child: Text(
                            entry.value['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  ))
              .toList(),
        );
      })),
    );
  }
}

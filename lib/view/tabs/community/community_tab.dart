import 'package:aura/managers/notification_manager.dart';
import 'package:aura/models/notification.dart' as no;
import 'package:aura/models/discussion_topic.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

Map<DiscussionTopic, String> bgImage = {
  DiscussionTopic.MEETUPS: "assets/topics_meetup.jpg",
  DiscussionTopic.GENERAL: "assets/General_discussion_topics.jpg",
  DiscussionTopic.FOOD: "assets/topics_food.jpg",
  DiscussionTopic.IT: "assets/IT_topics.jpg",
  DiscussionTopic.SPORTS: "assets/Sports_topic.webp",
  DiscussionTopic.NATURE: "assets/Nature_topic.jpeg",
};

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  List<no.Notification> notifications =
      []; // TODO: get notifications from controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuraAppBar(
        title: const Text('Community'),
        hasBackButton: false,
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
            ),
            onPressed: () {
              context.push("/settings");
            },
          )
        ],
      ),
      body: ListView(
        children: bgImage.keys
            .map<Widget>((topic) => Card(
                  child: InkWell(
                      onTap: () {
                        String newRoute = (topic.isThreadTopic())
                            ? "/tabs/community/topic/${topic.topic2parsable()}"
                            : "/tabs/community/meetups";

                        context.push(newRoute);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        height: 200,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(bgImage[topic]!),
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        child: Text(
                          topic.topic2readable(),
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
      ),
    );
  }
}

import 'package:aura/managers/notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NotificationsView()));
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
                onTap: _tapNotifs);
          })
        ],
      ),
      body: Center(child: Consumer<DiscussionManager>(
          builder: (context, discussionManager, child) {
        return ListView(
          // direction: Axis.vertical,
          // spacing: 20,

          children: topics.entries
              .map<Widget>((entry) => Card(
                    child: Container(
                      height: 200,
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(entry.value['bgImage']),
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      child: Text(
                        entry.value['name'],
                        textAlign: TextAlign.center,
                        style:
                           const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList()
          // ElevatedButton(
          //   onPressed: () {
          //     context.push("${GoRouter.of(context).location}/meetups");
          //   },
          //   child: Text('Meetups'),
          // ),
          ,
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

import 'package:aura/controllers/thread_controller.dart';
import 'package:aura/models/discussion_topic.dart';
import 'package:aura/view/tabs/community/fab_createthread.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:aura/managers/thread_manager.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../models/thread.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Thread_Manager()),
    ChangeNotifierProvider(create: (context) => User_Manager()),
  ], child: ThreadListView(topic: DiscussionTopic.NATURE)));
}

class ThreadListView extends StatefulWidget {
  final DiscussionTopic topic;

  const ThreadListView({Key? key, required this.topic}) : super(key: key);

  @override
  State<ThreadListView> createState() => ThreadListViewState();
}

class ThreadListViewState extends State<ThreadListView> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();
  late var thread_list = [];
  final filter = ProfanityFilter();
  var dropdownValue = 'Most Likes'; // default sort

  List<Thread> getThreads(){
    final threadMgr = Provider.of<Thread_Manager>(context, listen: false);
    final userMgr = Provider.of<User_Manager>(context, listen: false);
    switch (dropdownValue){
      case 'Most Likes': {
        return threadMgr
            .getListOfThreadsSortedByLikes(widget.topic);
      }
      case 'Most Recent': {
        return threadMgr
            .getListOfThreadsSortedByTime(widget.topic);
      }
      case 'My Threads': {
        return threadMgr
            .getListOfThreadsSortedByUser(topic: widget.topic,
            user_id: userMgr.active_user_id);
      }
      default: {
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AuraAppBar(
              title: Text(widget.topic.topic2readable())),
          floatingActionButton: FAB_CreateThread(topic: widget.topic),
          body: Consumer2<Thread_Manager, User_Manager>(
              builder: (context, threadMgr, userMgr, child) {
                Future<void> _handleRefresh () async {
                  await ThreadController.fetchThreads(context);
                }
                return Column(children: [
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      const Text("Sort by: "),
                      const SizedBox(width: 4),
                      DropdownButton<String>(
                        value: dropdownValue,
                        alignment: AlignmentDirectional.center,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            // if (newValue == 'Most Likes') {
                            //   thread_list = threadMgr
                            //       .getListOfThreadsSortedByLikes(widget.topic);
                            // } else if (newValue == 'Most Recent') {
                            //   thread_list = threadMgr
                            //       .getListOfThreadsSortedByTime(widget.topic);
                            // } else if (newValue == 'My Threads') {
                            //   print("Sorting by user");
                            //   thread_list = threadMgr
                            //       .getListOfThreadsSortedByUser(topic: widget.topic,
                            //       user_id: userMgr.active_user_id);
                            //   print(thread_list);
                            // }
                          });
                        },
                        items: <String>['Most Likes', 'Most Recent', 'My Threads']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Expanded(
                    child: LiquidPullToRefresh(
                      key: _refreshIndicatorKey,
                      color: Colors.grey[200],
                      backgroundColor: Colors.redAccent,
                      showChildOpacityTransition: false,
                      height: 75,
                      animSpeedFactor: 3,
                      onRefresh: _handleRefresh,
                      child: ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: (getThreads())
                              .map((t) => Card(
                              child: InkWell(
                                  onTap: () => context.push(
                                    // ? can we use an arrow function here? will it affect performance???
                                      "/tabs/community/thread/${t.id}"),
                                  child: Column(children: [
                                    const SizedBox(height: 8),
                                    SizedBox(
                                        child: ListTile(
                                            title: Text(filter.censor(
                                                t.title ?? "Untitled thread")),
                                            subtitle: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child: Text(
                                                  filter.censor(t.content),
                                                  style: TextStyle(),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                )),
                                            trailing: Container(
                                              height: 50,
                                              width: 80,
                                              alignment: const Alignment(1.0, 0.0),
                                              child: LikeButton(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                isLiked: t.isLikedBy(
                                                    userMgr.active_user_id),
                                                likeCount: t.numLikes(),
                                                onTap: (bool isLiked) async {
                                                  if (isLiked) {
                                                    threadMgr.removeLike(
                                                        t.id, userMgr.active_user_id);
                                                  } else {
                                                    threadMgr.addLike(
                                                        t.id, userMgr.active_user_id);
                                                  }
                                                  return !isLiked;
                                                },
                                                countPostion: CountPostion.left,
                                                circleColor: const CircleColor(
                                                    start: Colors.cyanAccent,
                                                    end: Colors.cyan),
                                                bubblesColor: const BubblesColor(
                                                  dotPrimaryColor: Colors.lightBlue,
                                                  dotSecondaryColor:
                                                  Colors.blueAccent,
                                                ),
                                                likeBuilder: (bool isLiked) {
                                                  return Icon(
                                                    Icons.thumb_up,
                                                    color: isLiked
                                                        ? Colors.blueAccent
                                                        : Colors.grey,
                                                  );
                                                },
                                                countBuilder: (int? count,
                                                    bool isLiked, String text) {
                                                  var color = isLiked
                                                      ? Colors.blueAccent
                                                      : Colors.grey;
                                                  return Container(
                                                      width: 30,
                                                      child: Text("$text",
                                                          style: TextStyle(
                                                            color: color,
                                                          ),
                                                          textAlign:
                                                          TextAlign.right));
                                                },
                                              ),
                                            ))),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(width: 16),
                                        Text(
                                          "Posted by: ${shortenUserName(t.userID)}", //TODO: lookup username via consumer
                                          // todo: fix/change how we use DefaultTextStyle
                                          // style: DefaultTextStyle.of(context)
                                          //     .style
                                          //     .apply(
                                          //         color: Colors.grey[700],
                                          //         fontStyle: FontStyle.italic)
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          DateFormat('yyyy-MM-dd kk:mm').format(t
                                              .timestamp), // TODO: lookup username via consumer
                                          // todo: fix/change how we use DefaultTextStyle
                                          // style: DefaultTextStyle.of(context)
                                          //     .style
                                          //     .apply(
                                          //         color: Colors.grey[700],
                                          //         fontStyle: FontStyle.italic)
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                  ]))),)
                              .toList()),
                    ),
                  )
                ]);
              })),
    );
  }
}


String shortenUserName(String name){
  if (name.length>=15){
    String short = name.substring(0,11);
    return short+"...";
  }
  return name;
}
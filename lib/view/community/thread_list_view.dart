import 'package:aura/models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:aura/managers/thread_manager.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

void main() => runApp(ThreadListView(
    active_thread_manager: Thread_Manager(),
    curr_user: User('1', 'Ryan'),
    topic: 'Nature'));

class ThreadListView extends StatefulWidget {
  final Thread_Manager active_thread_manager;
  final User curr_user;
  final String topic;

  const ThreadListView(
      {Key? key,
      required this.active_thread_manager,
      required this.curr_user,
      required this.topic})
      : super(key: key);

  @override
  State<ThreadListView> createState() => ThreadListViewState();
}

class ThreadListViewState extends State<ThreadListView> {
  late var thread_list =
      widget.active_thread_manager.getListOfThreadsSortedByLikes(widget.topic);

  var dropdownValue = 'Most Likes'; // default sort
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text("Specific topic"),
          ),
          body: Column(children: [
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
                      if (newValue == 'Most Likes') {
                        thread_list = widget.active_thread_manager
                            .getListOfThreadsSortedByLikes(widget.topic);
                      } else if (newValue == 'Most Recent') {
                        thread_list = widget.active_thread_manager
                            .getListOfThreadsSortedByTime(widget.topic);
                      }
                    });
                  },
                  items: <String>['Most Likes', 'Most Recent']
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
              child: ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: (thread_list)
                      .map((t) => Card(
                              child: Column(children: [
                            const SizedBox(height: 8),
                            SizedBox(
                                child: ListTile(
                                    title: Text(t.title ?? "Untitled thread"),
                                    onTap: null,
                                    subtitle: Container(
                                        margin: const EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child: Text(
                                          t.content,
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
                                        isLiked: t.isLikedBy(widget.curr_user),
                                        likeCount: t.numLikes(),
                                        onTap: (bool isLiked) async {
                                          if (isLiked) {
                                            widget.active_thread_manager.removeLike(
                                                widget.topic,
                                                t.id!,
                                                widget
                                                    .curr_user); // TODO use manager function
                                          } else {
                                            widget.active_thread_manager
                                                .addLike(widget.topic, t.id!,
                                                    widget.curr_user);
                                          }
                                          return !isLiked;
                                        },
                                        countPostion: CountPostion.left,
                                        circleColor: const CircleColor(
                                            start: Colors.cyanAccent,
                                            end: Colors.cyan),
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Colors.lightBlue,
                                          dotSecondaryColor: Colors.blueAccent,
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.thumb_up,
                                            color: isLiked
                                                ? Colors.blueAccent
                                                : Colors.grey,
                                          );
                                        },
                                        countBuilder: (int? count, bool isLiked,
                                            String text) {
                                          var color = isLiked
                                              ? Colors.blueAccent
                                              : Colors.grey;
                                          return Container(
                                              width: 30,
                                              child: Text("$text",
                                                  style: TextStyle(
                                                    color: color,
                                                  ),
                                                  textAlign: TextAlign.right));
                                        },
                                      ),
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(width: 16),
                                Text("Posted by: ${t.author.username}",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic)),
                                const SizedBox(width: 16),
                                Text(
                                    DateFormat('yyyy-MM-dd kk:mm')
                                        .format(t.timestamp),
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic)),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ])))
                      .toList()),
            )
          ])),
    );
  }
}

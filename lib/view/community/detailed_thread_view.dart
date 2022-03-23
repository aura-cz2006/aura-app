import 'dart:core';
import 'package:aura/managers/thread_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:aura/view/tabs/community/fab_createthread.dart';

import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

void main() {
  String threadID = "1";
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => Thread_Manager()),
      ChangeNotifierProvider(create: (context) => User_Manager()),
    ], child: DetailedThreadView(threadID: threadID)),
  );
}

class DetailedThreadView extends StatefulWidget {
  final String threadID;


  const DetailedThreadView(
      {Key? key, required this.threadID})
      : super(key: key);

  @override
  State<DetailedThreadView> createState() => _DetailedThreadViewState();
}

class _DetailedThreadViewState extends State<DetailedThreadView> {
  final textCtrl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: remove
      home: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          leading: const AppBarBackButton(),
          title: const Text(
              'Discussion Thread'), // TODO: maybe thread topic in appbar
        ),
        body: Consumer2<Thread_Manager, User_Manager>(
            builder: (context, threadMgr, userMgr, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(children: <Widget>[
                  DisplayFullThread(
                      threadID: widget.threadID),
                  DisplayThreadComments(
                      threadID: widget.threadID),
                  Row(children: [
                    Expanded(
                        child: TextField(
                      controller: textCtrl,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: "Leave a comment",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[750],
                          fontStyle: FontStyle.italic,
                        ),
                        fillColor: Colors.blueGrey[50],
                        filled: true,
                      ),
                      // validator: (String? value) { // TODO? validate for censored text
                      //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                      // },
                    )),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.grey[900]),
                      onPressed: () {
                        setState(() {
                          threadMgr.addComment(widget.threadID,
                              userMgr.active_user_id, textCtrl.text);
                          textCtrl.clear(); // clear text
                          FocusManager.instance.primaryFocus
                              ?.unfocus(); // exit keyboard
                        });
                      },
                    ),
                  ])
                ]),
              )
            ],
          );
        }),
      ),
    );
  }
}

class DisplayFullThread extends StatefulWidget {
  final String threadID;


  const DisplayFullThread(
      {Key? key, required this.threadID})
      : super(key: key);

  @override
  State<DisplayFullThread> createState() => _DisplayFullThreadState();
}

class _DisplayFullThreadState extends State<DisplayFullThread> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Thread_Manager, User_Manager>(
        builder: (context, threadMgr, userMgr, child) {
      return Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                    threadMgr.getThreadByID(widget.threadID)!.title ??
                        "Untitled Thread",
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 1.8, fontWeightDelta: 2)),
                trailing: (userMgr.active_user_id ==
                        threadMgr.getThreadByID(widget.threadID)!.userID)
                    ? PopupMenuButton(
                        onSelected: (value) {
                          setState(() {
                            if (value == "edit") {
                              context.push(
                                  "${GoRouter.of(context).location}/edit");
                            } else if (value == "delete") {
                              threadMgr.removeThread(widget.threadID);
                              context.pop();
                            }
                          });
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text("Edit"),
                                  ],
                                ),
                                value: "edit",
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: const [
                                    Icon(Icons.delete, size: 20),
                                    SizedBox(width: 8),
                                    Text("Delete"),
                                  ],
                                ),
                                value: "delete",
                              ),
                            ])
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 16),
                  Text(
                      userMgr.getUsernameByID(userMgr.active_user_id) ??
                          "UNKNOWN USER",
                      style: DefaultTextStyle.of(context).style.apply(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic)),
                  const SizedBox(width: 16),
                  Text(
                      DateFormat('yyyy-MM-dd kk:mm').format(
                          threadMgr.getThreadByID(widget.threadID)!.timestamp),
                      style: DefaultTextStyle.of(context).style.apply(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic)),
                ],
              ),
              ListTile(
                title: Text(threadMgr.getThreadByID(widget.threadID)!.content,
                    softWrap: true),
              ),
              // const SizedBox(height: 8),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 16),
                  LikeButton(
                    isLiked:
                        threadMgr.isLikedBy(widget.threadID, userMgr.active_user_id),
                    likeCount: threadMgr.getNumLikes(widget.threadID),
                    onTap: (bool isLiked) async {
                      if (isLiked) {
                        threadMgr.removeLike(
                            widget.threadID, userMgr.active_user_id);
                      } else {
                        threadMgr.addLike(widget.threadID, userMgr.active_user_id);
                      }
                      return !isLiked;
                    },
                    countPostion: CountPostion.left,
                    circleColor: const CircleColor(
                        start: Colors.cyanAccent, end: Colors.cyan),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Colors.lightBlue,
                      dotSecondaryColor: Colors.blueAccent,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.thumb_up,
                        color: isLiked ? Colors.blueAccent : Colors.grey,
                      );
                    },
                    countBuilder: (int? count, bool isLiked, String text) {
                      var color = isLiked ? Colors.blueAccent : Colors.grey;
                      Widget result;
                      result = Text(
                        "$text ",
                        style: TextStyle(color: color),
                      );
                      return result;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }
}

class DisplayThreadComments extends StatefulWidget {
  final String threadID;


  const DisplayThreadComments(
      {Key? key, required this.threadID})
      : super(key: key);

  @override
  State<DisplayThreadComments> createState() => _DisplayThreadCommentsState();
}

class _DisplayThreadCommentsState extends State<DisplayThreadComments> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Thread_Manager, User_Manager>(
        builder: (context, threadMgr, userMgr, child) {
      return ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: threadMgr
              .getCommentsForThread(widget.threadID)
              .map((c) => ListTile(
                    title: Text(c.text ?? ""),
                    subtitle: Text(
                        "${userMgr.getUsernameByID(c.userID)}    ${DateFormat('yyyy-MM-dd kk:mm').format(c.timestamp)}",
                        style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic)),
                    trailing: (userMgr.active_user_id == c.userID)
                        ? PopupMenuButton(
                            onSelected: (value) {
                              setState(() {
                                if (value == "delete") {
                                  threadMgr.removeComment(widget.threadID,
                                      c.commentID); // TODO: use manager function to delete comment
                                }
                              });
                            },
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Row(
                                      children: const [
                                        Icon(Icons.delete, size: 20),
                                        SizedBox(width: 8),
                                        Text("Delete"),
                                      ],
                                    ),
                                    value: "delete",
                                  ),
                                ])
                        : null,
                  ))
              .toList()); // move whatever was built in Widget build here
    });
  }
}

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/models/comment.dart';
import 'package:like_button/like_button.dart';

void main() {
  User user = User("USER_ID", "USERNAME");
  Thread test = Thread("TEST_ID", "This is the Title.", user,
      "This is the thread content.", DateTime.now());
  for (int i = 0; i < 5; i += 1) {
    test.addComment(
        Comment("C1", user, DateTime.now(), "$i) This is a comment."));
    test.addComment(
        Comment("C2", user, DateTime.now(), "$i) This is another comment."));
    test.addComment(
        Comment("C3", user, DateTime.now(), "$i) This is the last comment."));
  }
  User curr = User("CURR_UID", "CURR_USERNAME");
  runApp(DetailedThreadView(thread: test, currUser: curr));
}

class DetailedThreadView extends StatefulWidget {
  final Thread thread;
  final User currUser;
  const DetailedThreadView({Key? key, required this.thread, required this.currUser}) : super(key: key);

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
        title: const Text(
            'Discussion Thread'), // TODO: maybe thread topic in appbar
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(children: <Widget>[
            DisplayFullThread(thread: widget.thread, currUser: widget.currUser),
            DisplayThreadComments(comments: widget.thread.comments)
          ])),
          // CommentInputField(thread: widget.thread, currUser: widget.currUser),
          Row(children: [
            Expanded(
              child: TextField(
                controller: textCtrl,
                autocorrect: true,
                decoration: InputDecoration(
                  labelText: "Leave a comment",
                  labelStyle: TextStyle(fontSize: 18, color: Colors.grey[750], fontStyle: FontStyle.italic),
                  fillColor: Colors.blueGrey[50],
                  filled: true,
                ),
                // validator: (String? value) { // TODO? validate for censored text
                //   return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                // },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.grey[900]),
              onPressed: () { // TODO: assign unique comment ID
                setState(() {
                  widget.thread.addComment(Comment("CommID", widget.currUser, DateTime.now(), textCtrl.text));
                  textCtrl.clear(); // clear text
                  FocusManager.instance.primaryFocus?.unfocus(); // exit keyboard
                });
              },
            )
          ]),
        ],
      ),
    ));
  }
}

class DisplayFullThread extends StatefulWidget {
  final Thread thread;
  final User currUser;
  const DisplayFullThread({Key? key, required this.thread, required this.currUser}) : super(key: key);

  @override
  State<DisplayFullThread> createState() => _DisplayFullThreadState();
}

class _DisplayFullThreadState extends State<DisplayFullThread> {
  Future<bool> _handleTapLike(bool isLiked) async {
    if (isLiked) {
      widget.thread.removeLike(widget.currUser);
    } else {
      widget.thread.addLike(widget.currUser);
    }
    return !isLiked;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.thread.title ?? "Untitled Thread",
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.8, fontWeightDelta: 2)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: 16),
                Text(widget.thread.author.username,
                    style: DefaultTextStyle.of(context).style.apply(
                        color: Colors.grey[700], fontStyle: FontStyle.italic)),
                const SizedBox(width: 16),
                Text(
                    DateFormat('yyyy-MM-dd kk:mm')
                        .format(widget.thread.timestamp),
                    style: DefaultTextStyle.of(context).style.apply(
                        color: Colors.grey[700], fontStyle: FontStyle.italic)),
              ],
            ),
            ListTile(
              title: Text(widget.thread.content, softWrap: true),
            ),
            // const SizedBox(height: 8),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 16),
                LikeButton(
                  isLiked: widget.thread.isLikedBy(widget.currUser),
                  likeCount: widget.thread.numLikes(),
                  onTap: _handleTapLike,
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
  }
}

class DisplayThreadComments extends StatefulWidget {
  final List<Comment> comments;

  const DisplayThreadComments({Key? key, required this.comments})
      : super(key: key);

  @override
  State<DisplayThreadComments> createState() => _DisplayThreadCommentsState();
}

class _DisplayThreadCommentsState extends State<DisplayThreadComments> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: widget.comments
            .map((c) => ListTile(
                  title: Text(c.text ?? ""),
                  subtitle: Text(
                      "${c.author.username}\t\t${DateFormat('yyyy-MM-dd kk:mm').format(c.timestamp)}",
                      style: DefaultTextStyle.of(context).style.apply(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic)),
                ))
            .toList());
  }
}
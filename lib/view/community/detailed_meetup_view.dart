import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aura/models/meetup.dart';
import 'package:aura/models/user.dart';
import 'package:aura/models/comment.dart';
import 'package:latlong2/latlong.dart';
import 'package:like_button/like_button.dart';

void main() {
  User user = User("USER_ID", "USERNAME");
  Meetup test = Meetup(
    DateTime(2022, 03, 20, 23, 59),
    LatLng(0, 0),
    "MEETUP_ID",
    user,
    10,
    "This is the title of the meetup",
    "This is the meetup description.",
    DateTime.now(),
  );
  for (int i = 0; i < 5; i += 1) {
    test.addComment(
        Comment("C1", user, DateTime.now(), "$i) This is a comment."));
    test.addComment(
        Comment("C2", user, DateTime.now(), "$i) This is another comment."));
    test.addComment(
        Comment("C3", user, DateTime.now(), "$i) This is the last comment."));
  }
  User curr = User("CURR_UID", "CURR_USERNAME");
  runApp(DetailedMeetupView(meetup: test, currUser: curr));
}

class DetailedMeetupView extends StatefulWidget {
  final Meetup meetup;
  final User currUser;

  const DetailedMeetupView(
      {Key? key, required this.meetup, required this.currUser})
      : super(key: key);

  @override
  State<DetailedMeetupView> createState() => _DetailedMeetupViewState();
}

class _DetailedMeetupViewState extends State<DetailedMeetupView> {
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
        title: const Text('Meetup'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(children: <Widget>[
            DisplayFullMeetup(meetup: widget.meetup, currUser: widget.currUser),
            DisplayMeetupComments(comments: widget.meetup.comments)
          ])),
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
                      fontStyle: FontStyle.italic),
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
              onPressed: () {
                // TODO: assign unique comment ID
                setState(() {
                  widget.meetup.addComment(Comment("CommID", widget.currUser,
                      DateTime.now(), textCtrl.text));
                  textCtrl.clear(); // clear text
                  FocusManager.instance.primaryFocus
                      ?.unfocus(); // exit keyboard
                });
              },
            )
          ]),
        ],
      ),
    ));
  }
}

class DisplayFullMeetup extends StatefulWidget {
  final Meetup meetup;
  final User currUser;

  const DisplayFullMeetup(
      {Key? key, required this.meetup, required this.currUser})
      : super(key: key);

  @override
  State<DisplayFullMeetup> createState() => _DisplayFullMeetupState();
}

class _DisplayFullMeetupState extends State<DisplayFullMeetup> {
  // late Widget displayNumAttendees = DisplayNumAttendees(meetup: widget.meetup);

  Future<bool> _handleTapRSVP(bool isLiked) async {
    setState(() {
      if (isLiked) {
        widget.meetup.removeRsvpAttendee(widget.currUser);
      } else {
        widget.meetup.addRsvpAttendee(widget.currUser);
      }
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(widget.meetup.title ?? "Untitled Meetup",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.8, fontWeightDelta: 2)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 16),
              Text(widget.meetup.creator.username,
                  style: DefaultTextStyle.of(context).style.apply(
                      color: Colors.grey[700], fontStyle: FontStyle.italic)),
              const SizedBox(width: 16),
              Text(
                  "Posted at ${DateFormat('yyyy-MM-dd kk:mm').format(widget.meetup.createdAt)}",
                  style: DefaultTextStyle.of(context).style.apply(
                      color: Colors.grey[700], fontStyle: FontStyle.italic)),
            ],
          ),
          ListTile(
            title: Text(widget.meetup.description ?? "", softWrap: true),
          ),
          // displayNumAttendees, // DisplayNumAttendees(meetup: widget.meetup),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text("${widget.meetup.currNumAttendees()} "
                "/ ${widget.meetup.maxAttendees} ATTENDEES"),
          ),
          // const Divider(
          //   thickness: 1,
          //   color: Colors.grey,
          // ),
          ListTile( // TODO: display location address instead of coordinates
            leading: const Icon(Icons.pin_drop),
            title: Text("LAT ${widget.meetup.location.latitude}, LONG ${widget.meetup.location.longitude}"),
          ),
          ListTile(
            leading: const Icon(Icons.access_time_filled),
            title: Text(DateFormat('yyyy-MM-dd kk:mm').format(widget.meetup.timeOfMeetUp)),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              const Text("RSVP: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              LikeButton(
                size: 35,
                isLiked: widget.meetup.isAttending(widget.currUser),
                likeCount: widget.meetup.currNumAttendees(),
                onTap: _handleTapRSVP,
                circleColor: const CircleColor(
                    start: Colors.lightGreen, end: Colors.green),
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: Colors.lightGreenAccent,
                  dotSecondaryColor:
                      Colors.lightGreen, // TODO these colours kinda suck
                ),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    isLiked ? Icons.check_circle : Icons.close,
                    // isLiked ? Icons.person_add : Icons.person_remove,
                    color: isLiked ? Colors.green : Colors.grey[700],
                    size: 30,
                  );
                },
                countBuilder: (int? count, bool isLiked, String text) {
                  String? message;
                  var color;
                  color = isLiked ? Colors.green : Colors.grey[700];
                  message = " " +
                      (isLiked
                          ? "Yes, I will be there!"
                          : "Sorry, I will not be there.");
                  return Text(
                    (message),
                    style: TextStyle(color: color, fontSize: 18),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

class DisplayMeetupComments extends StatefulWidget {
  final List<Comment> comments;

  const DisplayMeetupComments({Key? key, required this.comments})
      : super(key: key);

  @override
  State<DisplayMeetupComments> createState() => _DisplayMeetupCommentsState();
}

class _DisplayMeetupCommentsState extends State<DisplayMeetupComments> {
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

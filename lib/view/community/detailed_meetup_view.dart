import 'dart:core';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

void main() {
  String userID = "1"; // viewer
  String meetupID = "1";
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Meetup_Manager()),
      ChangeNotifierProvider(create: (context) => User_Manager()),
    ],
    child: DetailedMeetupView(meetupID: meetupID, currUserID: userID),
  )); // curr
}

class DetailedMeetupView extends StatefulWidget {
  final String meetupID;
  final String currUserID;

  const DetailedMeetupView(
      {Key? key, required this.meetupID, required this.currUserID})
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
              leading: const AppBarBackButton(),
              title: const Text('Meetup'),
            ),
            body: Consumer2<Meetup_Manager, User_Manager>(
                builder: (context, meetupMgr, userMgr, child) {
              return Column(
                children: <Widget>[
                  Expanded(
                      child: ListView(children: <Widget>[
                    DisplayFullMeetup(
                        meetupID: widget.meetupID,
                        currUserID: widget.currUserID),
                    DisplayMeetupComments(
                        meetupID: widget.meetupID,
                        currUserID: widget.currUserID)
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
                        setState(() {
                          meetupMgr.addComment(widget.meetupID,
                              widget.currUserID, textCtrl.text);
                          textCtrl.clear(); // clear text
                          FocusManager.instance.primaryFocus
                              ?.unfocus(); // exit keyboard
                        });
                      },
                    )
                  ]),
                ],
              );
            })));
  }
}

class DisplayFullMeetup extends StatefulWidget {
  final String meetupID;
  final String currUserID;

  const DisplayFullMeetup(
      {Key? key, required this.meetupID, required this.currUserID})
      : super(key: key);

  @override
  State<DisplayFullMeetup> createState() => _DisplayFullMeetupState();
}

class _DisplayFullMeetupState extends State<DisplayFullMeetup> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Meetup_Manager, User_Manager>(
        builder: (context, meetupMgr, userMgr, child) {
      return Center(
        child: Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text(
                  meetupMgr.getMeetupByID(widget.meetupID).title ??
                      "Untitled Meetup",
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 1.8, fontWeightDelta: 2)),
              trailing: (widget.currUserID ==
                          meetupMgr.getMeetupByID(widget.meetupID).userID &&
                      meetupMgr.canEditMeetup(widget.meetupID))
                  ? PopupMenuButton(
                      onSelected: (value) {
                        setState(() {
                          if (value == "edit") {
                            context
                                .push("${GoRouter.of(context).location}/edit");
                          } else if (value == "delete") {
                            meetupMgr.cancelMeetup(widget.meetupID);
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
                    userMgr.getUsernameByID(
                        meetupMgr.getMeetupByID(widget.meetupID).userID)!,
                    style: DefaultTextStyle.of(context).style.apply(
                        color: Colors.grey[700], fontStyle: FontStyle.italic)),
                const SizedBox(width: 16),
                Text(
                    "Posted at ${DateFormat('yyyy-MM-dd kk:mm').format(meetupMgr.getMeetupByID(widget.meetupID).createdAt)}",
                    style: DefaultTextStyle.of(context).style.apply(
                        color: Colors.grey[700], fontStyle: FontStyle.italic)),
              ],
            ),
            ListTile(
              title: Text(
                  meetupMgr.getMeetupByID(widget.meetupID).description ?? "",
                  softWrap: true),
            ),
            // ListTile(
            //   leading: const Icon(Icons.people),
            //   title: meetupMgr.isCancelled(widget.meetupID)
            //       ? const Text("NO ATTENDEES",
            //           style: TextStyle(
            //               color: Colors.red, fontWeight: FontWeight.bold))
            //       : Text("${meetupMgr.getCurrNumAttendees(widget.meetupID)} "
            //           "/ ${meetupMgr.getMeetupByID(widget.meetupID).maxAttendees} ATTENDEES"),
            // ),
            ListTile(
              // TODO: display location address instead of coordinates
              leading: const Icon(Icons.pin_drop),
              title: Text(
                  "LAT ${meetupMgr.getMeetupByID(widget.meetupID).location.latitude}, LONG ${meetupMgr.getMeetupByID(widget.meetupID).location.longitude}"),
            ),
            ListTile(
              leading: const Icon(Icons.access_time_filled),
              title: Text(DateFormat('yyyy-MM-dd kk:mm').format(
                  meetupMgr.getMeetupByID(widget.meetupID).timeOfMeetUp)),
            ),
            Row(
              children: (meetupMgr.hasElapsed(widget.meetupID) ||
                      (meetupMgr.isCancelled(widget.meetupID)) ||
                      (meetupMgr.maxAttendeesReached(widget.meetupID)))
                  ? [
                      // no rsvp for elapsed / cancelled / full capacity meetups
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          const Text("RSVP: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 250,
                            child: Text(
                                (meetupMgr.isCancelled(widget.meetupID)
                                        ? "This meetup has been cancelled."
                                        : meetupMgr.maxAttendeesReached(
                                                widget.meetupID)
                                            ? "Maximum number of attendees has been reached."
                                            : "This meetup has elapsed.") +
                                    "\nNo more RSVPs are allowed.",
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ]
                  : [
                      // enable RSVP for upcoming meetup
                      const SizedBox(width: 16),
                      const Text("RSVP: ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      LikeButton(
                        size: 35,
                        isLiked: meetupMgr.isAttending(
                            widget.meetupID, widget.currUserID),
                        likeCount:
                            meetupMgr.getCurrNumAttendees(widget.meetupID),
                        onTap: (bool isLiked) async {
                          setState(() {
                            if (isLiked) {
                              meetupMgr.removeRsvpAttendee(
                                  widget.meetupID, widget.currUserID);
                            } else {
                              meetupMgr.addRsvpAttendee(
                                  widget.meetupID, widget.currUserID);
                            }
                          });
                          return !isLiked;
                        },
                        circleColor: const CircleColor(
                            start: Colors.lightGreen, end: Colors.green),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Colors.lightGreenAccent,
                          dotSecondaryColor: Colors.lightGreen,
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            isLiked ? Icons.check_circle : Icons.close,
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
            DisplayAttendees(
              isCancelled: meetupMgr.isCancelled(widget.meetupID),
              currNumAttendees: meetupMgr.getCurrNumAttendees(widget.meetupID),
              maxAttendees:
                  meetupMgr.getMeetupByID(widget.meetupID).maxAttendees,
              attendeeList: meetupMgr
                  .getAttendeeIDList(widget.meetupID)
                  .map((String userID) => userMgr.getUsernameByID(userID)!)
                  .toList(),
            ),
            // const SizedBox(height: 16),
          ]),
        ),
      );
    });
  }
}

class DisplayAttendees extends StatefulWidget {
  final bool isCancelled;
  final int currNumAttendees;
  final int maxAttendees;
  final List<String> attendeeList;

  const DisplayAttendees(
      {Key? key,
      required this.isCancelled,
      required this.currNumAttendees,
      required this.maxAttendees,
      required this.attendeeList})
      : super(key: key);

  @override
  State<DisplayAttendees> createState() => _DisplayAttendeesState();
}

class _DisplayAttendeesState extends State<DisplayAttendees> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return (ExpansionPanelList(
      elevation: 0,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _expanded = !_expanded;
        });
      },
      children: [
        ExpansionPanel(
            isExpanded: _expanded,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: const Icon(Icons.people),
                title: widget.isCancelled
                    ? const Text("NO ATTENDEES",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold))
                    : Text("${widget.currNumAttendees} "
                        "/ ${widget.maxAttendees}    ATTENDEES"),
              );
            },
            body: SizedBox(
              height: widget.attendeeList.length * 60,
              child: ListView(
                physics: const ScrollPhysics(),
                itemExtent: 60,
                children: widget.attendeeList
                    .map((String userName) => ListTile(
                          title: Text(userName),
                        ))
                    .toList(),
              ),
            ))
      ],
    ));
  }
}

class DisplayMeetupComments extends StatefulWidget {
  final String meetupID;
  final String currUserID;

  const DisplayMeetupComments(
      {Key? key, required this.meetupID, required this.currUserID})
      : super(key: key);

  @override
  State<DisplayMeetupComments> createState() => _DisplayMeetupCommentsState();
}

class _DisplayMeetupCommentsState extends State<DisplayMeetupComments> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Meetup_Manager, User_Manager>(
        builder: (context, meetupMgr, userMgr, child) {
      return ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: meetupMgr
              .getCommentsForMeetup(widget.meetupID)
              .map((c) => ListTile(
                    title: Text(c.text ?? ""),
                    subtitle: Text(
                        "${userMgr.getUsernameByID(c.userID)}    ${DateFormat('yyyy-MM-dd kk:mm').format(c.timestamp)}",
                        style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic)),
                    trailing: (widget.currUserID == c.userID)
                        ? PopupMenuButton(
                            onSelected: (value) {
                              setState(() {
                                if (value == "delete") {
                                  meetupMgr.removeComment(
                                      widget.meetupID, c.commentID);
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
              .toList());
    });
  }
}

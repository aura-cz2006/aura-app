import 'dart:core';
import 'package:aura/controllers/meetups_controller.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/widgets/app_bar_back_button.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:like_button/like_button.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';

class DetailedMeetupView extends StatefulWidget {
  final String meetupID;

  const DetailedMeetupView({Key? key, required this.meetupID})
      : super(key: key);

  @override
  State<DetailedMeetupView> createState() => _DetailedMeetupViewState();
}

class _DetailedMeetupViewState extends State<DetailedMeetupView> {
  final textCtrl = TextEditingController();
  final filter = ProfanityFilter();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AuraAppBar(
          title: const Text('Meetup'),
        ),
        body: Consumer2<Meetup_Manager, User_Manager>(
            builder: (context, meetupMgr, userMgr, child) {
          return Column(
            children: <Widget>[
              DisplayFullMeetup(meetupID: widget.meetupID),
              Expanded(child: DisplayMeetupComments(meetupID: widget.meetupID)),
              Row(children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      if (value != "") {
                        setState(() {
                          meetupMgr.addComment(
                              widget.meetupID, userMgr.active_user_id, value);
                          textCtrl.clear(); // clear text
                          FocusManager.instance.primaryFocus
                              ?.unfocus(); // exit keyboard
                        });
                      }
                    },
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
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.grey[900]),
                  onPressed: () {
                    if (textCtrl.text != "") {
                      setState(() async {
                        int response = await MeetupsController.createComment(meetup_id: widget.meetupID, content: textCtrl.text);

                        if (response == 200){
                          MeetupsController.fetchMeetups(context);
                          print("Comment Successful!");
                          textCtrl.clear(); // clear text
                          FocusManager.instance.primaryFocus
                              ?.unfocus(); // exit keyboard
                        }
                        if (response != 200){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    elevation: 10,
                                    scrollable: true,
                                    content: Center(
                                        child: Container(
                                          child: Text("Unable to delete comment.\n"
                                              "\n Please try again."),
                                        )
                                    )
                                );
                              });
                        }
                      });
                    }
                  },
                )
              ]),
            ],
          );
        }));
  }
}

class DisplayFullMeetup extends StatefulWidget {
  final String meetupID;

  const DisplayFullMeetup({Key? key, required this.meetupID}) : super(key: key);

  @override
  State<DisplayFullMeetup> createState() => _DisplayFullMeetupState();
}

class _DisplayFullMeetupState extends State<DisplayFullMeetup> {
  final filter = ProfanityFilter();

  @override
  Widget build(BuildContext context) {
    return Consumer2<Meetup_Manager, User_Manager>(
        builder: (context, meetupMgr, userMgr, child) {
      return Center(
        child: Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    filter.censor(
                        meetupMgr.getMeetupByID(widget.meetupID).title ??
                            "Untitled Meetup"),
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 1.8, fontWeightDelta: 2),
                    softWrap: true,
                  )),
              trailing: (userMgr.active_user_id ==
                          meetupMgr.getMeetupByID(widget.meetupID).userID &&
                      meetupMgr.canEditMeetup(widget.meetupID))
                  ? PopupMenuButton(
                      onSelected: (value) {
                        setState(() async {
                          if (value == "edit") {
                            context.push(
                                "${GoRouter.of(context).location}/editMeetup");
                          } else if (value == "delete") {
                            int response = await MeetupsController.deleteMeetup(meetup: meetupMgr.getMeetupByID(widget.meetupID));

                            if (response == 200) {
                              print("Delete Meetup Success!");
                            }

                            //Failure Message
                            if (response == 400){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        elevation: 10,
                                        scrollable: true,
                                        content: Center(
                                            child: Container(
                                              child: Text("Unable to delete meetup.\n"
                                                  "\n Please try again."),
                                            )
                                        )
                                    );
                                  });
                            }

                            MeetupsController.fetchMeetups(context);
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
              title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                      filter.censor(meetupMgr
                              .getMeetupByID(widget.meetupID)
                              .description ??
                          ""),
                      softWrap: true)),
            ),
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
                      (meetupMgr.maxAttendeesReached(widget.meetupID) &&
                          !meetupMgr.isAttending(
                              widget.meetupID, userMgr.active_user_id)))
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
                                (meetupMgr.hasElapsed(widget.meetupID)
                                        ? "This meetup has elapsed."
                                        : meetupMgr.isCancelled(widget.meetupID)
                                            ? "This meetup has been cancelled."
                                            : "Maximum number of attendees has been reached.") +
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
                            widget.meetupID, userMgr.active_user_id),
                        likeCount:
                            meetupMgr.getCurrNumAttendees(widget.meetupID),
                        onTap: (bool isLiked) async {
                          setState(() {
                            if (isLiked) {
                              meetupMgr.removeRsvpAttendee(
                                  widget.meetupID, userMgr.active_user_id);
                            } else {
                              meetupMgr.addRsvpAttendee(
                                  widget.meetupID, userMgr.active_user_id);
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
                          Color? color;
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

  const DisplayMeetupComments({Key? key, required this.meetupID})
      : super(key: key);

  @override
  State<DisplayMeetupComments> createState() => _DisplayMeetupCommentsState();
}

class _DisplayMeetupCommentsState extends State<DisplayMeetupComments> {
  final filter = ProfanityFilter();

  @override
  Widget build(BuildContext context) {
    return Consumer2<Meetup_Manager, User_Manager>(
        builder: (context, meetupMgr, userMgr, child) {
      return ListView(
          physics: const ScrollPhysics(),
          children: meetupMgr
              .getCommentsForMeetup(widget.meetupID)
              .map((c) => ListTile(
                    title: Text(filter.censor(c.text ?? "")),
                    subtitle: Text(
                        "${userMgr.getUsernameByID(c.userID)}    ${DateFormat('yyyy-MM-dd kk:mm').format(c.timestamp)}",
                        style: DefaultTextStyle.of(context).style.apply(
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic)),
                    trailing: (userMgr.active_user_id == c.userID)
                        ? PopupMenuButton(
                            onSelected: (value) {
                              setState(() async {
                                if (value == "delete") {
                                  int response = await MeetupsController.deleteMeetupComment(meetup_id: widget.meetupID, comment_id: c.commentID);

                                  if (response == 200){
                                    MeetupsController.fetchMeetups(context);
                                    print("Comment Deleted!");
                                  }
                                  if (response != 200){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              elevation: 10,
                                              scrollable: true,
                                              content: Center(
                                                  child: Container(
                                                    child: Text("Unable to delete comment.\n"
                                                        "\n Please try again."),
                                                  )
                                              )
                                          );
                                        });
                                  }
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

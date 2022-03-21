import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

void main() => runApp(MeetUpListView());

class MeetUpListView extends StatefulWidget {
  const MeetUpListView({Key? key}) : super(key: key);

  @override
  State<MeetUpListView> createState() => _MeetUpListViewState();
}

class _MeetUpListViewState extends State<MeetUpListView> {
  Meetup_Manager active_meetup_manager = Meetup_Manager();
  User curr_user = User('1', 'Ryan');
  late var meetup_list =
      active_meetup_manager.getMeetupsSortedByCreationDateTime();
  var dropdownValue = 'Most Recent';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              title: const Text("Meetups"),
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
                        if (newValue == 'Most Recent') {
                          meetup_list = active_meetup_manager
                              .getMeetupsSortedByCreationDateTime();
                        } else if (newValue == 'Starting Soon') {
                          meetup_list = active_meetup_manager
                              .getMeetupsSortedByTimeOfMeetUp();
                        } else if (newValue == 'Most Attendees') {
                          meetup_list = active_meetup_manager
                              .getMeetupsSortedByMostAttendees();
                        }
                      });
                    },
                    items: <String>[
                      'Most Recent',
                      'Starting Soon',
                      'Most Attendees'
                    ].map<DropdownMenuItem<String>>((String value) {
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
                    children: (meetup_list)
                        .map(
                          (m) => Card(
                            child: Column(children: [
                              const SizedBox(height: 8),
                              SizedBox(
                                  child: ListTile(
                                title: Text(m.title! + " on "+DateFormat('MM-dd kk:mm')
                                    .format(m.timeOfMeetUp),
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(
                                        color: Colors.grey[700],
                                        )),
                                onTap: null,
                                subtitle: Container(
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Text(
                                      "${m.currNumAttendees()}/${m.maxAttendees} Attendees"),
                                ),
                                trailing: Container(
                                  height: 50,
                                  width: 80,
                                  alignment: const Alignment(1.0, 0.0),
                                  child: LikeButton(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    isLiked: m.isAttending(curr_user),
                                    onTap: (bool isLiked) async {
                                      setState(() {
                                        if (isLiked) {
                                          m.removeRsvpAttendee(
                                              curr_user); // TODO use manager function
                                        } else {
                                          m.addRsvpAttendee(curr_user);
                                        }
                                      });
                                      return !isLiked;
                                    },
                                    circleColor: const CircleColor(
                                        start: Colors.lightGreen,
                                        end: Colors.green),
                                    bubblesColor: const BubblesColor(
                                      dotPrimaryColor: Colors.lightGreenAccent,
                                      dotSecondaryColor: Colors.lightGreen,
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.rsvp_rounded,
                                        // isLiked ? Icons.person_add : Icons.person_remove,
                                        color: isLiked
                                            ? Colors.green
                                            : Colors.grey[700],
                                        size: 30,
                                      );
                                    },
                                    countBuilder: (int? count, bool isLiked,
                                        String text) {
                                      String? message;
                                      var color;
                                      color = isLiked
                                          ? Colors.green
                                          : Colors.grey[700];
                                      // message = " " +
                                      //     (isLiked
                                      //         ? "Going!"
                                      //         : "RSVP");
                                      // return Text(
                                      //     (message),
                                      //     style: TextStyle(color: color, fontSize: 18));
                                    },
                                  ),
                                ),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(width: 16),
                                  Text("Posted by: ${m.creator.username}",
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic)),
                                  const SizedBox(width: 16),
                                  Text(
                                      DateFormat('yyyy-MM-dd kk:mm')
                                          .format(m.createdAt),
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(
                                          color: Colors.grey[700],
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ]),
                          ),
                        )
                        .toList()),

              ),
            ])));
  }
}

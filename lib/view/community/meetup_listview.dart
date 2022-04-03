import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/managers/user_manager.dart';
import 'package:aura/view/community/fab_createmeetup.dart';
import 'package:aura/widgets/aura_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:go_router/go_router.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Meetup_Manager()),
    ChangeNotifierProvider(create: (context) => User_Manager()),
  ], child: const MeetUpListView()));
}

class MeetUpListView extends StatefulWidget {
  const MeetUpListView({Key? key}) : super(key: key);

  @override
  State<MeetUpListView> createState() => _MeetUpListViewState();
}

class _MeetUpListViewState extends State<MeetUpListView> {
  final filter = ProfanityFilter();
  late var meetup_list = [];
  var dropdownValue = 'Most Recent';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AuraAppBar(title: const Text("Meetups")),
          floatingActionButton: const FAB_CreateMeetupView(),
          body: Consumer2<Meetup_Manager, User_Manager>(
              builder: (context, meetupMgr, userMgr, child) {
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
                        if (newValue == 'Most Recent') {
                          meetup_list =
                              meetupMgr.getMeetupsSortedByCreationDateTime();
                        } else if (newValue == 'Starting Soon') {
                          meetup_list =
                              meetupMgr.getMeetupsSortedByTimeOfMeetUp();
                        } else if (newValue == 'Most Attendees') {
                          meetup_list =
                              meetupMgr.getMeetupsSortedByMostAttendees();
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
                    children: ((meetup_list.isEmpty)
                            ? meetupMgr.getMeetupsSortedByCreationDateTime()
                            : meetup_list)
                        .map(
                          (m) => Card(
                            child: InkWell(
                              onTap: () => context.push(
                                  "/tabs/community/meetups/${m.meetupID}"),
                              child: Column(children: [
                                const SizedBox(height: 8),
                                SizedBox(
                                    child: ListTile(
                                  title: Text(
                                    filter.censor(m.title!) +
                                        " on " +
                                        DateFormat('MM-dd kk:mm')
                                            .format(m.timeOfMeetUp),
                                  ),
                                  subtitle: Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Text(
                                        "${m.currNumAttendees()}/${m.maxAttendees} Attendees"),
                                  ),
                                  trailing: Container(
                                    height: 70,
                                    width: 80,
                                    alignment: const Alignment(1.0, 0.0),
                                    child: (meetupMgr.maxAttendeesReached(
                                        m.meetupID) &&
                                        !meetupMgr.isAttending(m.meetupID,
                                            userMgr.active_user_id))
                                        ? Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: const [
                                          Icon(
                                            Icons.groups,
                                            color: Colors.redAccent,
                                          ),
                                          Text(
                                            "FULL",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ])
                                        : LikeButton(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      isLiked:
                                          m.isAttending(userMgr.active_user_id),
                                      onTap: (bool isLiked) async {
                                        setState(() {
                                          if (isLiked) {
                                            m.removeRsvpAttendee(
                                                userMgr.active_user_id);
                                          } else {
                                            m.addRsvpAttendee(
                                                userMgr.active_user_id);
                                          }
                                        });
                                        return !isLiked;
                                      },
                                      circleColor: const CircleColor(
                                          start: Colors.lightGreen,
                                          end: Colors.green),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor:
                                            Colors.lightGreenAccent,
                                        dotSecondaryColor: Colors.lightGreen,
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Column(
                                          children: [
                                            Expanded(
                                              child:
                                              Icon(
                                                isLiked
                                                    ? Icons.people
                                                    : Icons.people_outline,
                                                color: isLiked
                                                    ? Colors.green
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                            Expanded(
                                              child:
                                              Icon(
                                                Icons.rsvp,
                                                color: isLiked
                                                    ? Colors.green
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(width: 16),
                                    Text(
                                      "Posted by: ${userMgr.getUsernameByID(m.userID)}",
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      DateFormat('yyyy-MM-dd kk:mm')
                                          .format(m.createdAt),
                                      //     style: DefaultTextStyle.of(context)
                                      //         .style
                                      //         .apply(
                                      //             color: Colors.grey[700],
                                      //             fontStyle: FontStyle.italic)
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ]),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ]);
          })),
    );
  }
}

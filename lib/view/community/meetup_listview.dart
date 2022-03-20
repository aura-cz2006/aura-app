import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MeetUpListView());

class MeetUpListView extends StatefulWidget {
  const MeetUpListView({Key? key}) : super(key: key);

  @override
  State<MeetUpListView> createState() => _MeetUpListViewState();
}

class _MeetUpListViewState extends State<MeetUpListView> {
  Meetup_Manager active_meetup_manager = Meetup_Manager();
  User curr_user = User('1', 'Ryan');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text("Meetups"),
      ),
      body: ListView(
          children: (active_meetup_manager.getMeetupsSortedByCreationDateTime())
              .map(
                (m) => Card(child: ListTile(
                  title: Text(m.title),
                  onTap: null,
                  subtitle: Text(
                      "${m.currNumAttendees()}/${m.maxAttendees} Attendees"),
                  isThreeLine: true,
                  trailing: Text(DateFormat('yyyy-MM-dd kk:mm')
                      .format(m.timeOfMeetUp)),
                )
                ),
              )
              .toList()),
    ));
  }
}

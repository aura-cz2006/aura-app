import 'dart:html';

import 'package:aura/models/user.dart';

class Meetup {
  DateTime createdAt = DateTime.now();
  DateTime timeOfMeetUp;
  Geolocation location;
  String ID;
  User creator;
  int maxAttendees;
  List<User> rsvpAttendees = [];
  List<Comment> comments = [];

  Meetup(this.timeOfMeetUp, this.location, this.ID, this.creator, this.maxAttendees) {
    rsvpAttendees.add(creator);
  }

  int currNumAttendees(){
    return rsvpAttendees.length;
  }
}
import 'dart:html';

import 'package:aura/models/user.dart';

class Meetup {
  DateTime timestamp;
  Geolocation location;
  String ID;
  User creator;
  int maxAttendees;
  List<User> rsvpAttendees = [];
  List<Comment> comments = [];
  Meetup(this.timestamp, this.location, this.ID, this.creator, this.maxAttendees) {
    rsvpAttendees.add(creator);
  }
}
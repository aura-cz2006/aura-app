import 'dart:html';

import 'package:aura/models/user.dart';
import 'package:latlong2/latlong.dart';

class Meetup {
  DateTime createdAt = DateTime.now();
  DateTime timeOfMeetUp;
  LatLng location;
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

  void addRsvpAttendee(User user){
    rsvpAttendees.add(user);
  }

  void addComment(Comment newComment){
    comments.add(newComment);
  }

  void removeRsvpAttendee(User user){
    rsvpAttendees.remove(user);
  }
}
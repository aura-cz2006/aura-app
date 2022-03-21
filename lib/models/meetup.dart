import 'dart:html';

import 'package:aura/models/user.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/models/comment.dart';

class Meetup {
  String? title;
  String? description;
  DateTime createdAt;
  DateTime timeOfMeetUp;
  LatLng location;
  String ID;
  User creator;
  int maxAttendees;
  List<User> rsvpAttendees = [];
  List<Comment> comments = [];

  Meetup(this.timeOfMeetUp, this.location, this.ID, this.creator, this.maxAttendees, this.title, this.description, this.createdAt) {
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

  bool isAttending(User user){
    return rsvpAttendees.contains(user);
  }
}
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/models/comment.dart';

class Meetup {
  String? title;
  String? description;
  DateTime createdAt;
  DateTime timeOfMeetUp;
  LatLng location;
  String meetupID;
  String userID;
  int maxAttendees;
  List<String> rsvpAttendees = []; // userIDs
  List<Comment> comments = [];
  bool isCancelled = false;

  Meetup(this.timeOfMeetUp, this.location, this.meetupID, this.userID, this.maxAttendees, this.title, this.description, this.createdAt) {
    rsvpAttendees.add(userID);
  }

  int currNumAttendees(){
    return rsvpAttendees.length;
  }

  void addRsvpAttendee(String userID){
    rsvpAttendees.add(userID);
  }

  void removeRsvpAttendee(String userID){
    rsvpAttendees.remove(userID);
  }
  void addComment(String userID, String text) {
    Comment newC = Comment('commentID', userID, DateTime.now(), text); // todo set up unique comment id
    comments.add(newC);
  }

  void removeComment(String commentID){
    Comment comment = comments.firstWhere((c) => c.commentID == commentID);
    comments.remove(comment);
  }

  bool isAttending(String userID){
    return rsvpAttendees.contains(userID);
  }

  void cancel() {
    isCancelled = true;
  }

  bool maxAttendeesReached() {
    return (currNumAttendees() == maxAttendees);
  }

  bool canEdit() {
    return DateTime.now().isBefore(timeOfMeetUp.subtract(const Duration(hours: 3)));
  }

  bool hasElapsed() {
    return timeOfMeetUp.isBefore(DateTime.now());
  }

  String getSummary() {// TODO replace latlong display w address
    return "$title \nLocation: LAT ${location.latitude}, LONG ${location.longitude} \nTime: ${DateFormat('yyyy-MM-dd kk:mm').format(timeOfMeetUp)}";
  }

  int currNumAttendees(){
    return rsvpAttendees.length;
  }
}

import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/models/comment.dart';

class Meetup {
  late String? title;
  late String? description;
  late DateTime createdAt;
  late DateTime timeOfMeetUp;
  late LatLng location;
  late String meetupID;
  late String userID;
  late int maxAttendees;
  late List<String> rsvpAttendees = []; // userIDs
  late List<Comment> comments = [];
  late bool isCancelled = false;
  late Map<String, double> location_toback;
  late String address;


  Meetup(this.timeOfMeetUp, this.location, this.meetupID, this.userID,
      this.maxAttendees, this.title, this.description, this.createdAt) {
    rsvpAttendees.add(userID);
  }

  Meetup.toBackEnd({
    required this.title,
    required this.description,
    required this.timeOfMeetUp,
    required this.location_toback,
    required this.maxAttendees,
  });

  //Constructor for backend
  Meetup.fromBackEnd(
      this.title,
      this.description,
      this.createdAt,
      this.timeOfMeetUp,
      this.location,
      this.meetupID,
      this.userID,
      this.maxAttendees,
      this.comments,
      this.rsvpAttendees,
      this.isCancelled);


  int currNumAttendees() {
    return rsvpAttendees.length;
  }

  void addRsvpAttendee(String userID) {
    rsvpAttendees.add(userID);
  }

  void removeRsvpAttendee(String userID) {
    rsvpAttendees.remove(userID);
  }

  void addComment(String userID, String text) {
    Comment newC = Comment('commentID', userID, DateTime.now(),
        text); // todo set up unique comment id
    comments.add(newC);
  }

  void removeComment(String commentID) {
    Comment comment = comments.firstWhere((c) => c.commentID == commentID);
    comments.remove(comment);
  }

  bool isAttending(String userID) {
    return rsvpAttendees.contains(userID);
  }

  void cancel() {
    isCancelled = true;
  }

  bool maxAttendeesReached() {
    return (currNumAttendees() == maxAttendees);
  }

  bool canEdit() {
    return DateTime.now()
        .isBefore(timeOfMeetUp.subtract(const Duration(hours: 3)));
  }

  bool hasElapsed() {
    return timeOfMeetUp.isBefore(DateTime.now());
  }

  String getSummary() {
    // TODO replace latlong display w address
    return "$title \nLocation: LAT ${location.latitude}, LONG ${location.longitude} \nTime: ${DateFormat('yyyy-MM-dd kk:mm').format(timeOfMeetUp)}";
  }

  static List<Comment> constructCommentsListfromStringList(
      List<dynamic> jsonInputListOfMap) {
    List<Comment> result = [];

    for (dynamic item in jsonInputListOfMap) {
      Comment commentToAdd = Comment(item['id']!, item['user']!,
          DateTime.parse(item['timestamp']!), item['text']);
      result.add(commentToAdd);
    }
    return result;
  }

  // Future create(Map<String, dynamic> json) {
  //   Meetup meetup =
  // }

  Future<void> addAddress() async {
    this.address = await latLngtoAddress(this.location);
    // print("address = ${this.address}");
  }

  factory Meetup.getFromJson(Map<String, dynamic> json) {
    // print("LatLng type looks like this!!!!!!!!!!!!!!!!! ");
    // print(LatLng((json['location']['lat']), (json['location']['lng'])));
    Meetup meetup = Meetup.fromBackEnd(
        json['title'],
        json['description'],
        DateTime.parse(json['createdAt']),
        DateTime.parse(json['meetupTime']),
        LatLng((json['location']['lat']), (json['location']['lng'])),
        json['id'],
        json['userID'],
        json['maxAttendees'],
        constructCommentsListfromStringList(json['comments']),
        List<String>.from(json['rsvpAttendees']),
        json['isCancelled']);
    //
    // meetup.latLngtoAddress(LatLng((json['location']['lat']), (json['location']['lng'])));
    // print("Addres========================${meetup.address}================");
    return meetup;
  }
}

Future<String> latLngtoAddress(LatLng coord) async {
  var placemarks = await placemarkFromCoordinates(coord.latitude, coord.longitude);
  var interest = placemarks.first;
  return interest.street! + ", " + interest.postalCode!;
}


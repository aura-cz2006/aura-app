// import 'package:aura/models/user.dart';

class Meetup { // TODO
  String? title;
  // DateTime? dateTime;
  // Geolocation? location;
  String? id;
  // int? maxAttendees;
  // List<User> rsvpAttendees;

  // constructor
  Meetup(this.id, this.title);
  // Meetup(this.title, this.dateTime, this.location, this.id, this.maxAttendees) : rsvpAttendees = [];

  @override
  String toString() {
    // return 'Meetup: {id: ${id ?? ""}, title: ${title ?? ""}, dateTime: $dateTime, location: $location, max: $maxAttendees, rsvpNum: ${rsvpAttendees.length}}';
    return 'Meetup: {id: ${id ?? ""}, title: ${title ?? ""}}';
  }
}

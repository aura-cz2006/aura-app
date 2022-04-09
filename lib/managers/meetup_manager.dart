import 'package:aura/models/comment.dart';
import 'package:aura/models/meetup.dart';
import 'package:aura/util/manager.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class Meetup_Manager extends Manager {
  var meet_up_list = [
    // Meetup(DateTime.now().add(Duration(days: 2)), LatLng(1.34, 103.68), '1',
    //     '1', 5, 'Table tennis', 'I love the high speed game.', DateTime.now()),
    // Meetup(DateTime.now().add(Duration(days: 1)), LatLng(1.3868, 103.8914), '2',
    //     '2', 15, 'Hackathon', 'I love python.', DateTime.now()),
    // Meetup(DateTime.now().add(Duration(days: 4)), LatLng(1.3612, 103.8863), '3',
    //     '3', 10, 'Muay Thai', 'I love beating people up.', DateTime.now()),
    // Meetup(DateTime.now().add(Duration(days: 4)), LatLng(1.2707, 103.8099), '4',
    //     '4', 7, 'Botanic Gardens', 'I love plants.', DateTime.now()),
    // Meetup(DateTime.now().add(Duration(days: 4)), LatLng(1.3385, 103.7304), '5',
    //     '5', 8, 'Sightseeing', 'I love exploring the city.', DateTime.now()),
    // Meetup(DateTime.now().add(Duration(days: 4)), LatLng(1.2942, 103.7861), '6',
    //     '6', 2, 'Anime', 'I love Attack on Titan.', DateTime.now()),
  ];

  void updateMeetupList(List<Meetup> meetupList){
    meet_up_list = meetupList;
    // for (Meetup meetup in meet_up_list){
    //   print(meetup.getSummary());
    // }
    print(meetupList);
  }

  List<Meetup> getValidMeetups() {
    List<Meetup> validList = [];
    for (var each in meet_up_list) {
      if (each.timeOfMeetUp.isAfter(DateTime.now()) && !each.isCancelled) {
        validList.add(each);
      }
    }
    return validList;
  }

  List<Meetup> getMeetupsSortedByTimeOfMeetUp() {
    var list = getValidMeetups();
    list.sort((a, b) => a.timeOfMeetUp.compareTo(b.timeOfMeetUp));
    return list;
  }

  List<Meetup> getMeetupsSortedByCreationDateTime() {
    var list = getValidMeetups();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<Meetup> getMeetupsSortedByMostAttendees() {
    var temp_list = [];
    var validList = getValidMeetups();
    for (var meetup in validList) {
      if (meetup.currNumAttendees() == meetup.maxAttendees) {
        validList.remove(meetup);
        temp_list.add(meetup);
      }
    }
    validList
        .sort((a, b) => b.currNumAttendees().compareTo(a.currNumAttendees()));
    for (var each in temp_list) {
      validList.add(each);
    }
    return validList;
  }

  Meetup getMeetupByID(String meetupID) {
    return meet_up_list.firstWhere((m) => m.meetupID == meetupID);
  }

  void cancelMeetup(String meetupID) {
    getMeetupByID(meetupID).cancel();
    notifyListeners();
  }

  int getCurrNumAttendees(String meetupID) {
    return getMeetupByID(meetupID).currNumAttendees();
  }

  void addRsvpAttendee(String meetupID, String userID) {
    getMeetupByID(meetupID).addRsvpAttendee(userID);
    notifyListeners();
  }

  void removeRsvpAttendee(String meetupID, String userID) {
    getMeetupByID(meetupID).removeRsvpAttendee(userID);
    notifyListeners();
  }

  void addComment(String meetupID, String userID, String text) {
    Meetup meetup = getMeetupByID(meetupID);
    meetup.addComment(userID, text);
    notifyListeners();
  }

  void removeComment(String meetupID, String commentID) {
    Meetup meetup = getMeetupByID(meetupID);
    meetup.removeComment(commentID);
    notifyListeners();
  }

  bool isAttending(String meetupID, String userID) {
    return getMeetupByID(meetupID).isAttending(userID);
  }

  bool maxAttendeesReached(String meetupID) {
    return getMeetupByID(meetupID).maxAttendeesReached();
  }

  bool canEditMeetup(String meetupID) {
    return getMeetupByID(meetupID).canEdit();
  }

  void editMeetup(String meetup_id, DateTime new_date, String new_title,
      String new_desc, LatLng new_location, int new_max_attendees) {
    var meetupForEdit = getMeetupByID(meetup_id);
    meetupForEdit.timeOfMeetUp = new_date;
    meetupForEdit.title = new_title;
    meetupForEdit.description = new_desc;
    meetupForEdit.location = new_location;
    meetupForEdit.maxAttendees = new_max_attendees; // todo check constraint
    notifyListeners();
  }

  bool hasElapsed(String meetupID) {
    return getMeetupByID(meetupID).hasElapsed();
  }

  bool isCancelled(String meetupID) {
    return getMeetupByID(meetupID).isCancelled;
  }

  List<Comment> getCommentsForMeetup(String meetupID) {
    return getMeetupByID(meetupID).comments;
  }

  List<String> getAttendeeIDList(String meetupID) {
    return getMeetupByID(meetupID).rsvpAttendees;
  }

  void addMeetup(DateTime timeofMeetup, LatLng location, String userID, int maxAttendees, String title, String description){
    Meetup meetup_to_add = Meetup(timeofMeetup, location, generateUUID(), userID, maxAttendees, title, description, DateTime.now());
    meet_up_list.add(meetup_to_add);
    notifyListeners();
  }

  String generateUUID(){
    return (meet_up_list.length+1).toString();
  }

  String latlngToString(LatLng coord) {
    GeocodingPlatform.instance;
    var placemarks = placemarkFromCoordinates(coord.latitude, coord.longitude);
    late String address;
    placemarks.then((data) {
      var interest = data.first;
      address = interest.street! + ", " + interest.postalCode!;
      return address;
    });
    return address;
  }
}

import 'package:aura/models/meetup.dart';
import 'package:aura/util/manager.dart';
import 'package:latlong2/latlong.dart';

class Meetup_Manager extends Manager {
  var meet_up_list = [
    Meetup(
        DateTime.now().add(Duration(days: 2)),
        LatLng(1.34, 103.68),
        '1',
        '1',
        5,
        'Table tennis',
        'I love the high speed game.',
        DateTime.now()),
    Meetup(DateTime.now().add(Duration(days: 1)), LatLng(1.3868, 103.8914), '2',
        '2', 15, 'Hackathon', 'I love python.', DateTime.now()),
    Meetup(
        DateTime.now().add(Duration(days: 4)),
        LatLng(1.3612, 103.8863),
        '3',
        '3',
        10,
        'Muay Thai',
        'I love beating people up.',
        DateTime.now()),
    Meetup(
        DateTime.now().add(Duration(days: 4)),
        LatLng(1.2707, 103.8099),
        '4',
        '4',
        7,
        'Botanic Gardens',
        'I love plants.',
        DateTime.now()),
    Meetup(
        DateTime.now().add(Duration(days: 4)),
        LatLng(1.3385, 103.7304),
        '5',
        '5',
        8,
        'Sightseeing',
        'I love exploring the city.',
        DateTime.now()),
    Meetup(
        DateTime.now().add(Duration(days: 4)),
        LatLng(1.2942, 103.7861),
        '6',
        '6',
        2,
        'Anime',
        'I love Attack on Titan.',
        DateTime.now()),
  ];

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
        .sort((a, b) => a.currNumAttendees().compareTo(b.currNumAttendees()));
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

  int getCurrNumAttendees(String meetupID){
    return getMeetupByID(meetupID).currNumAttendees();
  }

  void addRsvpAttendee(String meetupID, String userID){
    getMeetupByID(meetupID).addRsvpAttendee(userID);
    notifyListeners();
  }

  void removeRsvpAttendee(String meetupID, String userID){
    getMeetupByID(meetupID).removeRsvpAttendee(userID);
    notifyListeners();
  }

  void addComment(String meetupID, String userID, String text) {
    Meetup meetup = getMeetupByID(meetupID);
    meetup.addComment(userID, text);
    notifyListeners();
  }

  void removeComment(String meetupID, String commentID){
    Meetup meetup = getMeetupByID(meetupID);
    meetup.removeComment(commentID);
    notifyListeners();
  }

  bool isAttending(String meetupID, String userID){
    return getMeetupByID(meetupID).isAttending(userID);
  }

  bool maxAttendeesReached(String meetupID) {
    return getMeetupByID(meetupID).maxAttendeesReached();
  }
}

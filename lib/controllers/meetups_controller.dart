import 'package:aura/apis/meetup_api.dart';
import 'package:aura/managers/meetup_manager.dart';
import 'package:aura/models/meetup.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MeetupsController {
  static void fetchMeetups(BuildContext context) async {
    // call api (convert to dart there) and receive api data
    List<Meetup> fetchedMeetupItems = await MeetUpAPI.fetchMeetups();

    // call provider
    Provider.of<Meetup_Manager>(context, listen: false)
        .updateMeetupList(fetchedMeetupItems);
  }

  static Future<int> createMeetup(
  {required String title,
    required String content,
    required int maxAttendees,
    required DateTime timeofMeetup,
    required LatLng location}) {
    print("in MeetupController\n");
    Meetup newMeetup = Meetup.toBackEnd(
        title: title,
        description: content,
        timeOfMeetUp: timeofMeetup,
        location_toback: locationLatLngtoMapForBackEnd(location),
        maxAttendees: maxAttendees);
    return MeetUpAPI.postMeetup(meetup: newMeetup);
  }

  static Future<int> editMeetup(
      {required String title,
        required String content,
        required int maxAttendees,
        required DateTime timeofMeetup,
        required LatLng location}) {
    print("in MeetupController\n");
    Meetup editMeetup = Meetup.toBackEnd(
        title: title,
        description: content,
        timeOfMeetUp: timeofMeetup,
        location_toback: locationLatLngtoMapForBackEnd(location),
        maxAttendees: maxAttendees);
    return MeetUpAPI.patchMeetup(meetup: editMeetup);
  }
}

Map<String, double> locationLatLngtoMapForBackEnd(LatLng coord){
  Map<String, double> result = {
    "lat" : coord.latitude,
    "long" : coord.longitude,
  };
  return result;
}

import 'dart:convert';
import 'package:aura/models/meetup.dart';
import 'package:aura/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';


class MeetUpAPI{
  static Future<List<Meetup>> fetchMeetups() async {
    Uri url = Uri.parse("${Config().routes["api"]}/meetups/");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;

      // use dart:convert to decode JSON
      List<dynamic> decodedJson =
      json.decode(responseBody); // todo put this back

      List<Meetup> resList = await (decodedJson).map((item) {
        return Meetup.getFromJson(item);
      }).toList();
      for (Meetup item in resList){
        print("Title: ${item.title}, Location: ${item.location}");
      }

      for(Meetup item in resList){
        await item.addAddress();
      }

      return resList;
    } else {
      print(
          "ERROR fetching Meetups: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }

  // static Future<List<Meetup>> fetchDiscussionComments() async {
  //   Uri url = Uri.parse("${Config().routes["api"]}/discussions/");
  //
  //   http.Response response = await http.get(url);
  //
  //   if (response.statusCode == StatusCode.OK) {
  //     String responseBody = response.body;
  //
  //     // use dart:convert to decode JSON
  //     List<dynamic> decodedJson =
  //     json.decode(responseBody); // todo put this back
  //
  //     List<Meetup> resList = (decodedJson).map((item) {
  //       return Meetup.getFromJson(item);
  //     }).toList();
  //
  //     print(resList);
  //
  //     return resList;
  //   } else {
  //     print(
  //         "ERROR fetching Meetups: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
  //     return [];
  //   }
  // }

  static Future<int> patchMeetup({required Meetup meetup}) async {
    print("Entered API\n");
    Uri url = Uri.parse(
        "${Config().routes["api"]}/meetups/${meetup.meetupID}");

    // var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    //print("Going to post to the HTTP now@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22");
    final response = await http.patch(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          // "Authorization": "Bearer ${token}"
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          'title': meetup.title!,
          "description": meetup.description,
          "meetupTime": meetup.timeOfMeetUp.toString(),
          "location": json.encode(meetup.location_toback), //Todo: check if this location is a map
          "maxAttendees": meetup.maxAttendees.toString(),
        });
    //print("RESPONSE POSTED@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    return response.statusCode; //200 == Success, 400 == Failure.
  }

  static Future<int> postMeetup({required Meetup meetup}) async {
    print("Entered API\n");
    Uri url = Uri.parse(
        "${Config().routes["api"]}/meetups/");
    print("URI parsed. Posting to server...\n");
    print(url.toString());
    // var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    //print("Going to post to the HTTP now@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          // "Authorization": "Bearer ${token}"
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          'title': meetup.title!,
          "description": meetup.description,
          "meetupTime": meetup.timeOfMeetUp.toString(),
          "location": json.encode(meetup.location_toback), //Todo: check if this location is a map
          "maxAttendees": meetup.maxAttendees.toString(),
        });
    //print("RESPONSE POSTED@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    return response.statusCode; //200 == Success, 400 == Failure.
  }

  static Future<int> deleteMeetup({required Meetup meetup}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/meetups/${meetup.meetupID}");

    // var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        // "Authorization": "Bearer ${token}"
      },
      encoding: Encoding.getByName('utf-8'),
    );

    return response.statusCode;
  }

  static Future<int> postMeetupComment({required String comment_text, required String meetup_id}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/discussions/${meetup_id}/comments");
    var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    //print("Going to post to the HTTP now@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer ${token}"
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "meetup_id": meetup_id,
          "text": comment_text,
        });
    //print("RESPONSE POSTED@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    return response.statusCode; //200 == Success, 400 == Failure.
  }

  static Future<int> deleteMeetupComment({required String meetup_id, required String comment_id}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/discussions/${meetup_id}/comments/${comment_id}");

    // var token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        // "Authorization": "Bearer ${token}"
      },
      encoding: Encoding.getByName('utf-8'),
    );

    return response.statusCode;
  }
}


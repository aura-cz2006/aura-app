import 'dart:convert';
import 'package:aura/models/meetup.dart';
import 'package:aura/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';
import 'package:latlong2/latlong.dart';


class MeetUpAPI{
  static Future<List<Meetup>> fetchMeetups() async {
    Uri url = Uri.parse("${Config().routes["api"]}/meetups/");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;

      // use dart:convert to decode JSON
      List<dynamic> decodedJson =
      json.decode(responseBody); // todo put this back

      List<Meetup> resList = (decodedJson).map((item) {
        return Meetup.getFromJson(item);
      }).toList();

      print(resList);

      return resList;
    } else {
      print(
          "ERROR fetching Meetups: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }

  static Future<int> patchMeetup({required Meetup meetup}) async {
    print("Entered API\n");
    Uri url = Uri.parse(
        "${Config().routes["api"]}/meetups/${meetup.meetupID}");

    //print("Going to post to the HTTP now@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22");
    final response = await http.patch(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
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
    print(json.encode(meetup.location_toback).runtimeType);
    //print("Going to post to the HTTP now@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
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

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    return response.statusCode;
  }

  static Future<int> postMeetupComment({required String comment_text, required String meetup_id}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/discussions/${meetup_id}/comments");
    //print("Going to post to the HTTP now@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@22");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
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

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    return response.statusCode;
  }
}

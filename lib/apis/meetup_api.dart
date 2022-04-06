import 'dart:convert';
import 'package:aura/models/meetup.dart';
import 'package:aura/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';


class MeetUpAPI{
  static Future<List<Meetup>> fetchMeetups() async {
    Uri url = Uri.parse("${Config().routes["api"]}/meetups/");

    http.Response response = await http.get(url);

    if (response.statusCode == StatusCode.OK) {
      String responseBody = response.body;

      // use dart:convert to decode JSON
      List<dynamic> decodedJson =
      json.decode(responseBody); // todo put this back

      //print(decodedJson);

      List<Meetup> resList = (decodedJson).map((item) {
        return Meetup.getFromJson(item);
      }).toList();

      print(resList);
      //print("HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO");

      return resList;
    } else {
      print(
          "ERROR fetching Meetups: ${response.statusCode} ${getStatusMessage(response.statusCode)}");
      return [];
    }
  }

  static Future<int> postMeetup({required Meetup meetup}) async {
    Uri url = Uri.parse(
        "${Config().routes["api"]}/meetups/");

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          'title': meetup.title!,
          "description": meetup.description,
          "meetupTime": meetup.timeOfMeetUp,
          "location": meetup.location, //Todo: check if this location is a map
          "maxAttendees": meetup.maxAttendees,
        });

    return response.statusCode; //200 == Success, 400 == Failure.
  }
}
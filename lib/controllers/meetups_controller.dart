import 'package:aura/models/meetup.dart';
import 'package:latlong2/latlong.dart';

class MeetupsController {
  static Meetup getMeetup(String ID) {
    // TODO: get the list of meetups from manager and return the meetup with the matching ID
    return Meetup(DateTime.now().add(Duration(days: 2)), LatLng(1.34, 103.68), '1',
        '1', 5, 'Table tennis', 'I love the high speed game.', DateTime.now());

  }
}
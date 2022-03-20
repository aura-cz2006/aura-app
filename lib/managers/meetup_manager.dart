import 'package:aura/models/meetup.dart';
import 'package:aura/models/user.dart';
import 'package:aura/util/manager.dart';
import 'package:latlong2/latlong.dart';



class Meetup_Manager extends Manager {
  var meet_up_list = [
    Meetup(
        DateTime.now().add(Duration(days: 2)), LatLng(1.34,103.68), '1', User('1', 'Ryan'),
        5), Meetup(
        DateTime.now().add(Duration(days: 1)), LatLng(1.3868,103.8914), '2',
        User('2', 'Dyllon'),
        15), Meetup(
        DateTime.now().add(Duration(days: 4)), LatLng(1.3612,103.8863), '3',
        User('3', 'Jamie'),
        10), Meetup(
        DateTime.now().add(Duration(days: 4)), LatLng(1.2707,103.8099), '4',
        User('4', 'Alan'),
        7), Meetup(
        DateTime.now().add(Duration(days: 4)), LatLng(1.3385,103.7304), '5',
        User('5', 'Nicole'),
        8), Meetup(
        DateTime.now().add(Duration(days: 4)), LatLng(1.2942,103.7861), '6',
        User('6', 'Fath'),
        2),
  ];

      List<Meetup> getMeetupsSortedByTimeOfMeetUp(){
        meet_up_list.sort((a,b) => b.timeOfMeetUp.compareTo(a.timeOfMeetUp));
        return meet_up_list;
      }

      List<Meetup> getMeetupsSortedByCreationDateTime(){
        meet_up_list.sort((a,b) => b.createdAt.compareTo(a.createdAt));
        return meet_up_list;
      }

      List<Meetup> getMeetupsSortedByMostAttendees(){
        var temp_list = [];
        for (var meetup in meet_up_list){
          if (meetup.currNumAttendees() == meetup.maxAttendees){
            meet_up_list.remove(meetup);
            temp_list.add(meetup);
          }
        }
        meet_up_list.sort((a,b) => a.currNumAttendees().compareTo(b.currNumAttendees()));
        for (var each in temp_list){
          meet_up_list.add(each);
        }
        return meet_up_list;
      }
}
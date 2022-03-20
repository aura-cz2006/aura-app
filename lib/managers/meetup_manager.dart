import 'package:aura/models/meetup.dart';
import 'package:aura/models/user.dart';
import 'package:aura/util/manager.dart';

import 'package:geolocator/geolocator.dart';


class Meetup_Manager extends Manager {
  var meet_up_list = [
    Meetup(
        DateTime.now().add(Duration(days: 2)), 'Dakota', '1', User('1', 'Ryan'),
        5), Meetup(
        DateTime.now().add(Duration(days: 1)), 'SengKang', '2',
        User('2', 'Dyllon'),
        15), Meetup(
        DateTime.now().add(Duration(days: 4)), 'Hougang', '3',
        User('3', 'Jamie'),
        10), Meetup(
        DateTime.now().add(Duration(days: 4)), 'Telok Blangah', '4',
        User('4', 'Alan'),
        7), Meetup(
        DateTime.now().add(Duration(days: 4)), 'Chinese Garden', '5',
        User('5', 'Nicole'),
        8), Meetup(
        DateTime.now().add(Duration(days: 4)), 'Queenstown', '6',
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
      }
}
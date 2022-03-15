import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/util/manager.dart';

class Thread_Manager extends Manager{
  var threadMap = {
    'Nature': [
      Thread('1', 'Otters spotted at Marina Bay Sands!',
          User('u1', 'Nicole Lim'), 'what a rare sight!'),
      Thread('2', 'Rafflesia spotted at Raffles City', User('u2', 'Alan Seng'),
          'what a gorgeous specimen!')
    ],
    'Food!': [
      Thread('3', 'Delicious Japanese food at Ion Orchard',
          User('u3', 'Ryan Khong'), 'Yummy and affordable')
    ],
    'IT': [
      Thread('4', 'New SSD out on the market!', User('u4', 'Dyllon'),
          'so much memory at such an affordable price!')
    ],
    'Sports': [
      Thread('5', 'New Muay Thai facility in NTU', User('u5', 'Jamie Goh'),
          'Time to beat some people')
    ],
    'General Discussion': [
      Thread('6', 'Attack on Titan Exhibition at Art Science Museum!',
          User('u6', 'Fathima'), 'Rumbling, rumbling, it\'s coming!')
    ]
  };

  // Map<String, List<Thread>> getMapFromController(){
  //   //this function gets threadMap from thread_controller which gets it from API
  // }



}

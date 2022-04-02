import 'package:aura/models/user.dart';
import 'package:aura/util/manager.dart';
import 'package:latlong2/latlong.dart';

class User_Manager extends Manager {

  String active_user_id = "1";
  late LatLng location_data;

  var user_list = [
    User('1', 'Ryan'),
    User('2', 'Nicole'),
    User('3', 'Dyllon'),
    User('4', 'Alan'),
    User('5', 'Jamie'),
    User('6', 'Fath')
  ];


  User? getUser(String id){
    for (var each in user_list){
      if (each.id == id){
        return each;
      }
    }
  }

  void updateHomeAddress(String id, String new_home_address){
    var curr_user = getUser(id);
    curr_user!.updateHomeAddress(new_home_address);
    notifyListeners();
  }

  String? getUsernameByID(String id){
    for (var each in user_list){
      if (each.id == id){
        return each.username;
      }
    }
  }

  void updateLocation(LatLng coord){
    location_data = coord;
    notifyListeners();
  }

  LatLng getLocation(){
    return location_data;
  }


}

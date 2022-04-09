import 'package:aura/models/user.dart';
import 'package:aura/util/manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
 
class User_Manager extends Manager {
  String active_user_id = "3";
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

  void updateHomeAddress_String(String id, LatLng coord) async {
    var placemarks = await placemarkFromCoordinates(coord.latitude, coord.longitude);
    var interest = placemarks.first;
    String address = interest.street! + ", " + interest.postalCode!;

    var curr_user = getUser(id);
    curr_user!.updateHomeAddressString(address);
    print(address);
    notifyListeners();
  }

  void updateHomeAddress(String id, LatLng new_home_address) async {
    var placemarks = await placemarkFromCoordinates(new_home_address.latitude, new_home_address.longitude);
    var interest = placemarks.first;
    String address = interest.street! + ", " + interest.postalCode!;

    var curr_user = getUser(id);
    curr_user!.updateHomeAddress(new_home_address);
    curr_user.updateHomeAddressString(address);

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

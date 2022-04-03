import 'package:latlong2/latlong.dart';

class User {
  late String id;
  late String username;
  late LatLng homeaddress_coord;
  String homeaddress_string = '';

  User(this.id, this.username);

  void updateHomeAddress(LatLng newHomeAddress){
    homeaddress_coord = newHomeAddress;
  }

  void updateHomeAddressString(String newAddress){
    homeaddress_string = newAddress;
  }

  String getHomeAddress(){
    return homeaddress_string;
  }
}

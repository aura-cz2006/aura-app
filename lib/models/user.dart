class User {
  late String id;
  late String username;
  String homeaddress = '';

  User(this.id, this.username);

  void updateHomeAddress(String newHomeAddress){
    homeaddress = newHomeAddress;
  }
}

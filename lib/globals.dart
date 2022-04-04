import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? prefs;
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void hasOnboarded() async {
    prefs!.setBool("hasOnboarded", true);
  }

  static bool getOnboarded() {
    return prefs!.getBool("hasOnboarded")!;
  }

}
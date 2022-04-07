import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class Auth {
  // sync sign in status

  static User? authStatus;

  static void setAuthState(User? user) {
    print("debug: setting auth state");
    authStatus = user;
  }

  static User? getAuthState() {
    return authStatus;
  }
}

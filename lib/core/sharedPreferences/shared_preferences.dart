import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static String loginSharedPreference = "LOGGEDINKEY";

// save data

  static Future<bool> saveLoginSharedPreference(islogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(loginSharedPreference, islogin);
  }

//fetch data

  static Future getUserSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(loginSharedPreference);
  }
}

class SharedPrefsHelper {
  static Future<void> setVisitedOnboarding(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('visitedOnboarding', value);
  }

  static Future<bool> getVisitedOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('visitedOnboarding') ?? false;
  }

  static Future<void> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('visitedOnboarding');
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProvider {

  static const firstStartupLabel = "startup";
  

  static Future<bool> isFirstStartup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool startup = prefs.getBool(firstStartupLabel) ?? true;
    return startup;
  }

  static setIsFirstStartup(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(firstStartupLabel, value);
  }

}
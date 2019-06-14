import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProvider {

  static SharedPreferences ___prefs;

  static get prefs async {
    if(___prefs == null)
      ___prefs = await SharedPreferences.getInstance();
    return ___prefs;
  }

}
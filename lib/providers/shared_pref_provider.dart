import 'package:shared_preferences/shared_preferences.dart';

/// Wraps a singleton of an instance of [SharedPreferences] that
/// provide persistent local storage on device (iOS and Android)
/// 
/// Use this provider if you want to read / write / delete object
/// store in the shared preference space. 
/// 
/// IMPORTANT : use shared preference only for small data as settings 
/// parameters, account name, etc. If you want to store larger data
/// use other storage solution as SQLite (e.g. exercise_local_storage
/// module use SQLite to store user exercises progression)
class SharedPrefProvider {

  static SharedPreferences ___prefs;

  static get prefs async {
    if(___prefs == null)
      ___prefs = await SharedPreferences.getInstance();
    return ___prefs;
  }

}
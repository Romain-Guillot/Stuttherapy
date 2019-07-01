import 'package:shared_preferences/shared_preferences.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/exercise_library/exercises.dart';
import 'package:stutterapy/providers/shared_pref_provider.dart';

class AccountProvider {
  static User user;

  static const existingAccount = "existingAccount";

  
  static setUser(User _user) {
    user = _user;
  }

  
  static Future<bool> getSavedUser() async {
    SharedPreferences _prefs = await SharedPrefProvider.prefs;
    String accountType = _prefs.getString(existingAccount);
    if(accountType == null)
      return false;
    switch (accountType) {
      case StutterUser.userIdentifier:
        user = StutterUser.restore(
          progression: {},
          userSavedWord: {}
        );
        return true;
      case TherapistUser.userIdentifier:
        user = TherapistUser.restore(
          progression: {},
          userSavedWord: {}
        );
        return true;
      default:
        return false;
    }
  }

  static setSavedUser(User _user) async {
    SharedPreferences _prefs = await SharedPrefProvider.prefs;
    switch (_user.runtimeType) {
      case StutterUser:
        _prefs.setString(existingAccount, StutterUser.userIdentifier);
        break;
      case TherapistUser:
        _prefs.setString(existingAccount, TherapistUser.userIdentifier);
        break;
    }
  }

    
}
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/providers/shared_pref_provider.dart';

class AccountProvider {
  static const existingAccount = "existingAccount";
  
  
  static Future<User> getSavedUser() async {
    SharedPreferences _prefs = await SharedPrefProvider.prefs;
    String accountType = _prefs.getString(existingAccount);
    if(accountType == null)
      return UninitializeUser();
    switch (accountType) {
      case StutterUser.userIdentifier:
        return StutterUser();
      case TherapistUser.userIdentifier:
        return TherapistUser();
      default:
        return UninitializeUser();
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
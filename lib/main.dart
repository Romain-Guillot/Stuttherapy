import 'package:flutter/material.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/providers/account_provider.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/homepage_stutter.dart';
import 'package:stutterapy/ui/homepage_therapist.dart';
import 'package:stutterapy/ui/startup.dart';


void main() async => runApp(Stutterapy());


/// Entry point of the application.
/// This widget create the material application.
/// If it's the first application startup :
///   =>  The [StartUp] widget is displayed
/// Else
///   =>  Depending of the user type, either [HomePageStutter] or
///       [HomePageTherapist] is displayed (if user is a [StutterUser] or 
///       a [TherapistUser]).
/// 
class Stutterapy extends StatelessWidget {

  Stutterapy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(96, 33, 255, 1),
      ),
      home:FutureBuilder<User>(
        future: AccountProvider.getSavedUser(),
        builder: (BuildContext ctx, AsyncSnapshot<User> _userSnapshot) {
          if(_userSnapshot.data == null) {
            return LoadingScreen();
          } else {
            if(_userSnapshot.data.runtimeType == UninitializeUser) {
              return StartUp();
            } else {
              Manager _manager = Manager(user: _userSnapshot.data);
              return _userSnapshot.data.runtimeType == StutterUser ? 
                        HomePageStutter(manager: _manager) : 
                        HomePageTherapist(manager: _manager);
            }
          }
        },
      ),
    );
  }
}


/// Loading screen, just a centered circular progress indicator
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CircularProgressIndicator(value: null,), // undetermine circular progress
    );
  }
}
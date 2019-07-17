import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/homepage_stutter.dart';
import 'package:stuttherapy/ui/homepage_therapist.dart';
import 'package:stuttherapy/ui/startup.dart';


/*
Regroue SettingsItemWidget to one super widget
*/
final MaterialColor primary = MaterialColor(
  1,
  {
    50: Color.fromRGBO(255, 210, 255, 1),
    100: Color.fromRGBO(189, 156, 255, 1),
    200: Color.fromRGBO(169, 126, 255, 1),
    300: Color.fromRGBO(146, 92, 255, 1),
    400: Color.fromRGBO(122, 56, 255, 1),
    500: Color.fromRGBO(93, 21, 238, 1),
    600: Color.fromRGBO(76, 7, 213, 1),
    700: Color.fromRGBO(58, 6, 164, 1),
    800: Color.fromRGBO(41, 3, 118, 1),
  }
);

final Color secondaryColor = Color.fromRGBO(234, 145, 49, 1);
final Color secondaryColorDarker = Color.fromRGBO(255, 172, 82, 1);

void main() async { 

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: primary[400], // navigation bar color
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent, // status bar color
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light
  ));
  runApp(Stutterapy());
}


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
      title: Strings.APP_NAME,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.light, 
          color: Colors.transparent, 
          elevation: 0, 
          iconTheme: IconThemeData(color: Colors.black), 
          textTheme: TextTheme(
            title: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            subtitle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300),
            button: TextStyle(color: primary[400]),
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black
          )
        ),
        
        // primarySwatch: primary,
        buttonTheme: ButtonThemeData(
          buttonColor: primary[400], 
          textTheme: ButtonTextTheme.primary,
        ),
        primaryColor: primary[400],
        primaryColorDark: primary[700],
        primaryColorLight: primary[200],

        
        backgroundColor: Colors.white,
        sliderTheme: SliderThemeData(
          // thumbColor: primary[700],
          // activeTrackColor: primary[700],
          // inactiveTrackColor: primary[200],
          // overlayColor: primary[400].withAlpha(20)
          thumbColor: secondaryColorDarker,
          activeTrackColor: secondaryColorDarker,
          inactiveTrackColor: secondaryColor.withAlpha(100),
          overlayColor: secondaryColor.withAlpha(30)
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide(width: 1))
        ),

        accentColor: secondaryColor,

      ),
      home:FutureBuilder<bool>(
        future: AccountProvider.getSavedUser(),
        builder: (BuildContext ctx, AsyncSnapshot<bool> _userSnapshot) {
          if(_userSnapshot.data == null) {
            return LoadingScreen();
          } else {
            if(_userSnapshot.data == false) {
              return StartUp();
            } else {
              switch (AccountProvider.user.runtimeType) {
                case StutterUser:
                  return HomePageStutter();
                case TherapistUser:
                  return HomePageTherapist();
                default:
                  return Text("Critical error !");
              }
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
      body: Center(child: CircularProgressIndicator(value: null,)), // undetermine circular progress
    );
  }
}
import 'package:flutter/material.dart';
import 'package:stutterapy/providers/shared_pref_provider.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/startup.dart';

void main() async {
  runApp(Stutterapy());
}

///
///
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
      home:FutureBuilder<bool>(
        future: SharedPrefProvider.isFirstStartup(),
        builder: (BuildContext ctx, AsyncSnapshot<bool> isFirstStatutSnapshot) {
          if(isFirstStatutSnapshot.data == null) {
            return LoadingScreen();
          }else {
            if(isFirstStatutSnapshot.data) {
              return StartUp();
            }else {
              
              return const Text("TODO NOT FIRST START_UP");
            }
          }
        },
      ),
    );
  }
}


///
///
///
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}
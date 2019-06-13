import 'package:flutter/material.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/homepage_stutter.dart';
import 'package:stutterapy/ui/homepage_therapist.dart';

///
///
///
class StartUp extends StatefulWidget {

  StartUp({Key key}) : super(key: key);

  @override
  _StartUpState createState() => _StartUpState();
}


///
///
///
class _StartUpState extends State<StartUp> {

  final List<Type> choices = [StutterUser, TherapistUser];
  Type selectedAccount;

  /// Notice : Direct body child of the Scaffold is a Builder to have a correct context
  ///          to display a snackbar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext newCtx) =>
      SafeArea(
        child: Column(
          children: <Widget>[
            Text(Strings.startupTitle),
            _choicesWidget(),
            RaisedButton(
              child: Text(Strings.startupSubmitButton),
              onPressed: () {
                _submitChoice(newCtx);
              },
            ),
          ],
        ),
      ),
    ));
  }

  ///
  ///
  _submitChoice(BuildContext ctx) {
    // widget.manager.setFirstStartupValue(false);
    Widget _appropriateHomePage;

    switch (selectedAccount) {
      case TherapistUser: 
        _appropriateHomePage = HomePageTherapist(
          manager: Manager(user: TherapistUser())
        );   
        break;
      case StutterUser:
        _appropriateHomePage = HomePageStutter(
          manager: Manager(user: StutterUser())
        );
        break;
    }

    if(_appropriateHomePage != null) {
      Navigator.pushReplacement(ctx, MaterialPageRoute(
        builder: (BuildContext bc) => _appropriateHomePage
      ));
    }else {
      final snack = SnackBar(content: Text(Strings.startupErrorNoAccountTypeSelected));
      Scaffold.of(ctx).showSnackBar(snack);
    }
  }

  ///
  ///
  Widget _choicesWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: choices.length,
        itemBuilder: (BuildContext ctx, int position) {
          Type _currentAccount = choices[position];
          return RaisedButton(
            child: Text(_getAccountIdentifier(_currentAccount)),
            color: (selectedAccount == _currentAccount) ? Colors.green : Colors.white,
            onPressed: () {
              setState(() {
                selectedAccount = _currentAccount;
              });
            },
          );
        },
      ),
    );
  }

  String _getAccountIdentifier(Type accountType) {
    switch (accountType) {
      case TherapistUser:
        return TherapistUser.userIdentifier;
      case StutterUser:
        return StutterUser.userIdentifier;
      default:
        return "Type not handled";
    }
  }
}
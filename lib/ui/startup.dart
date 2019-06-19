import 'package:flutter/material.dart';
import 'package:stutterapy/account/accounts.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/dimen.dart';
import 'package:stutterapy/ui/homepage_stutter.dart';
import 'package:stutterapy/ui/homepage_therapist.dart';

/// Start-up page, display when it's the first application launch (or first 
/// launch without go further).
/// 
/// This widget displayed a welcomed message with an applicaiton introduction.
/// User have to chose the type of account that he wants :
/// - [StutterUser] if it's a basic user that want to use application to do
///   exercises
/// - [TherapistUser] is it's a professionnal medicial therapist that want to help
///   [StutterUser]
class StartUp extends StatefulWidget {

  StartUp({Key key}) : super(key: key);

  @override
  _StartUpState createState() => _StartUpState();
}


/// State of [StartUp] widget that handled the choice made by the user 
/// between the two types of account available in the app.
/// 
/// The user chose is tracked with [selectedAccount] variable. Before that user
/// submit his choice no [User] object is created ! User choice is handled and track thanks
/// to the [Type] type.
/// 
/// When the user submit his choice, he can go further and a [Manager] is created with an
/// [User] object according to his choice.
///
class _StartUpState extends State<StartUp> {

  final List<Type> choices = [StutterUser, TherapistUser];
  Type selectedAccount;

  /// Notice : Direct body child of the Scaffold is a Builder to have a correct context
  ///          to display a snackbar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(builder: (BuildContext newCtx) =>
        Padding(
          padding: const EdgeInsets.all(Dimen.STARTUP_PADDING),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.STARTUP_TITLE, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),),
                SizedBox(height: 20,),
                Text(Strings.STARTUP_INTRO, style: TextStyle(fontSize: 15, color: Colors.white, height: 1.12)),
                SizedBox(height: 20,),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: _choicesWidget()
                  ),
                ),
                Expanded(child: SizedBox(),),
                Center(
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    disabledColor: Theme.of(context).accentColor.withAlpha(100),
                    child: Text(Strings.STARTUP_SUBMIT),
                    onPressed: selectedAccount == null ? null :  () {
                      _submitChoice(newCtx);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  /// Function called when the user submit his choice
  /// The function check if an [User] [Type] is selected (even if the 
  /// UI prevent the submit access if no [User] [Type] is selected).
  /// So, if a [User] [Type] is selected, the route is changed according to
  /// the user choice ([HomePageTherapist] or [HomePageStutter]). A manager
  /// is created with a new [User] ([TherapistUser] or [StutterUser]) and pass throught the new 
  /// widget.
  _submitChoice(BuildContext ctx) {
    Widget _appropriateHomePage;
    User _user;

    switch (selectedAccount) {
      case TherapistUser: 
        _user = TherapistUser();
        _appropriateHomePage = HomePageTherapist(
          manager: Manager(user: _user)
        );   
        break;
      case StutterUser:
        _user = StutterUser();
        _appropriateHomePage = HomePageStutter(
          manager: Manager(user: _user)
        );
        break;
    }

    if(_appropriateHomePage != null) {
      // SharedPrefProvider.setSavedUser(_user);
      Navigator.pushReplacement(ctx, MaterialPageRoute(
        builder: (BuildContext bc) => _appropriateHomePage
      ));
    }else {
      final snack = SnackBar(content: Text(Strings.STARTUP_ERROR_NO_ACCOUNT_SELECTED));
      Scaffold.of(ctx).showSnackBar(snack);
    }
  }

  /// Return the widget composed of the list of account type
  /// available (so [TherapistUser] and [StutterUser]). Each account
  /// type is dislayed as a [RaiseButton] and it is selectionnable.
  Widget _choicesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: choices.map((Type _currentAccount) {
          return RaisedButton(
            child: Text(_getAccountIdentifier(_currentAccount)),
            color: (selectedAccount == _currentAccount) ? Colors.green : Colors.white,
            onPressed: () {
              setState(() {
                selectedAccount = _currentAccount;
              });
            },
          );
        }).toList()
    );
  }

  /// Return simply the accont type identifier
  /// Maybe find a best way to achieve this ...
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
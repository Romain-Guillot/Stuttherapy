import 'package:flutter/material.dart';
import 'package:stutterapy/account/accounts.dart';

class MainAppBar extends AppBar {
  MainAppBar({
    @required Widget title,
    @required User user,
  }) : super(
    title: title,
    actions: !user.isLogged ? [LogIn()] : [AccountInfo(user: user)]
  );
}

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("Log in".toUpperCase()),
      onPressed: () {},
    );
  }
}

class AccountInfo extends StatelessWidget {

  final User user;

  AccountInfo({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      user.pseudo
    );
  }
}
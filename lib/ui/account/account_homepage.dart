import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';

class AccountHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: "Account",
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimen.PADDING),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Sign out"), 
              color: Theme.of(context).errorColor,
              onPressed: () {
                AccountProvider.logOutUser();
                Navigator.pop(context);
              }, 
            )
          ],
        ),
      )
    );
  }
}
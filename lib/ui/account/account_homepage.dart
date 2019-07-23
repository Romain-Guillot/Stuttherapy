import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:tinycolor/tinycolor.dart';

class AccountHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: "Account",
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Dimen.PADDING),
              child: Text("Account type : ${AccountProvider.user.identifier}"),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimen.PADDING),
              child: RaisedButton(
                child: Text("Sign-out"), 
                // color: Theme.of(context).errorColor,
                onPressed: () {
                  AccountProvider.logOutUser();
                  Navigator.pop(context);
                }, 
              ),
            ),
            Container(
              color: Theme.of(context).errorColor.withAlpha(35),
              padding: const EdgeInsets.all(Dimen.PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Delete your account ?", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: TinyColor(Theme.of(context).errorColor).darken(15).color, fontSize: 17),
                  ),
                  Text(
                    "Once you delete your account, there is no going back. Please be certain.",
                    style: TextStyle(color: TinyColor(Theme.of(context).errorColor).darken(15).color),
                  ),
                  RaisedButton(
                    color: Theme.of(context).errorColor,
                    child: Text("Delete my account"),
                    onPressed: () {
                      showDialog(context: context, builder: (context)=> SimpleDialog(title: Text("Soon..."), titlePadding: EdgeInsets.all(20),));
                    },
                  ),
                  SizedBox(width: double.infinity,)
                ],
              )
            )
          ],
        ),
      )
    );
  }
}
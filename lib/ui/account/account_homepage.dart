import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:tinycolor/tinycolor.dart';

class AccountHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: Strings.ACCOUNT_TITLE,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Dimen.PADDING),
              child: Text(Strings.ACCOUNT_TYPE_LABEL + " ${AccountProvider.user.identifier}"),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimen.PADDING),
              child: RaisedButton(
                child: Text(Strings.ACCOUNT_SIGNOUT), 
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
                    Strings.ACCOUNT_DELETE_TITLE, 
                    style: TextStyle(fontWeight: FontWeight.bold, color: TinyColor(Theme.of(context).errorColor).darken(15).color, fontSize: 17),
                  ),
                  Text(
                    Strings.ACCOUNT_DELETE_INFO,
                    style: TextStyle(color: TinyColor(Theme.of(context).errorColor).darken(15).color),
                  ),
                  RaisedButton(
                    color: Theme.of(context).errorColor,
                    child: Text(Strings.ACCOUNT_DELETE_ACTION),
                    onPressed: () {
                      showDialog(
                        context: context, 
                        builder: (context) => SimpleDialog(
                          title: Text("Soon..."), 
                          titlePadding: EdgeInsets.all(20),
                        )
                      );
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
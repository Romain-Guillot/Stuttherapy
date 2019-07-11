
import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/ui/account/account_log_in.dart';
import 'package:stuttherapy/ui/account/saved_words.dart';
import 'package:stuttherapy/ui/components/main_appbar.dart';

class DrawerMenu extends Drawer {

  final BuildContext context;

  DrawerMenu(this.context);

  

  @override
  Widget get child {
    return Builder(
      builder: (newContext) => SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // UserAccountsDrawerHeader(
            //   accountName: Text("ok"),
            //   accountEmail: Text("kjndksf"),
            //   currentAccountPicture: CircleAvatar(backgroundColor: Colors.red,),
            // ),
            ListTile(
              title: RaisedButton(child:Text("Log-in"), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLogIn()));
              },),
              subtitle: FlatButton(child:Text("Sign-up"),textColor: Theme.of(context).primaryColor, onPressed: () {},),
            ),
            ListTile(
              title: Text("Saved words"),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => SavedWordsWidget()
              )),
            ),
            ListTile(
              title: Text("Synchronisation"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Wipe my progressions"),
              onTap: () {
                Navigator.pop(context);
                AccountProvider.wipeProgressions().then(
                  (_) =>
                    Scaffold.of(newContext).showSnackBar(
                      SnackBar(content: Text("Progression wiped !"), behavior: SnackBarBehavior.floating)
                    ),
                  onError: (e) => 
                    Scaffold.of(newContext).showSnackBar(
                        SnackBar(content: Text("Something went wrong ..."), behavior: SnackBarBehavior.floating)
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
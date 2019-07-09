
import 'package:flutter/material.dart';
import 'package:stutterapy/providers/account_provider.dart';
import 'package:stutterapy/providers/exercise_local_storage.dart';
import 'package:stutterapy/ui/account/saved_words.dart';

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
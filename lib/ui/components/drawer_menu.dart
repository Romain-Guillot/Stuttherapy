
import 'package:flutter/material.dart';
import 'package:stutterapy/ui/account/saved_words.dart';

class DrawerMenu extends Drawer {

  final BuildContext context;

  DrawerMenu(this.context);

  @override
  Widget get child {
    return SafeArea(
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
        )
      ],
    ),
  );;
  }

}
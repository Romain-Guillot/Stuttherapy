
import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/ui/account/account_homepage.dart';
import 'package:stuttherapy/ui/account/account_log_in.dart';
import 'package:stuttherapy/ui/account/saved_words.dart';
import 'package:stuttherapy/ui/components/auth_buttons.dart';


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
            accountInformation(),
            ListTile(
              title: Text("Saved words"),
              subtitle: Text("All your words saved during your trainings."),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => SavedWordsWidget()
              )),
            ),
            ListTile(
              title: Text("Wipe local progressions"),
              subtitle: Text("Deleted progressions saved on your device. It will not affect your cloud progressions."),
              onTap: () => wipeLocalProgression(newContext),
            ),
            ListTile(
              title: Text("Backup cloud progression"),
              subtitle: Text("Exercises progression synchronise in the cloud will be downladed on your device."),
              onTap: () => backupProgression(newContext)
            ),
          ],
        ),
      ),
    );
  }

  wipeLocalProgression(context) {
    Navigator.pop(context);
    AccountProvider.wipeProgressions().then(
      (_) =>
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Progression wiped !"), behavior: SnackBarBehavior.floating)
        ),
      onError: (e) => 
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Something went wrong ..."), behavior: SnackBarBehavior.floating)
        )
    );
  }

  backupProgression(BuildContext context) async {
    Navigator.pop(context);
    try {
      if(AccountProvider.user.isLogged) {
        await AccountProvider.backupProgression();
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Progressions downloaded !"), behavior: SnackBarBehavior.floating,)
        );
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => AccountLogIn(initialFormMode: FormMode.SIGNIN,)
        ));
      }
    } catch(err) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(context).errorColor,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }

  accountInformation() {
    return StreamBuilder(
      stream: AccountProvider.user.loggedUserStream,
      builder: (BuildContext context, AsyncSnapshot<LoggedUser> snapUser) {
        if(snapUser.hasError) {
          return Container(
            color: Theme.of(context).errorColor,
            child: Text("Error..."),
          );
        }
        if(!snapUser.hasData || snapUser.data.user == null) {
          return AuthButton();
        } else {
          LoggedUser user = snapUser.data;
          return Container( // Container inside an InkWell inside a Material inside a Container to handle ripple effect and background color ...
            color: Theme.of(context).primaryColor,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Container(
                  child: ListTileTheme(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text("Your profile", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email, style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
                      
                    ),
                  ),
                ),
                onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AccountHomePage()
                  ));
                },
              ),
            ),
          );
        }
      },
    );
  }
}
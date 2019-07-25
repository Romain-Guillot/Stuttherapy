
import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/strings.dart';
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
              title: Text(Strings.SAVED_WORDS_TITLE),
              subtitle: Text(Strings.SAVED_WORDS_DESCRIPTION),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => SavedWordsWidget()
              )),
            ),
            ListTile(
              title: Text(Strings.WIPE_LOCAL_PROGRESS),
              subtitle: Text(Strings.WIPE_LOCAL_PROGRESS_DESCRIPTION),
              onTap: () => wipeLocalProgression(newContext),
            ),
            ListTile(
              title: Text(Strings.BACKUP_CLOUD_PROGRESS),
              subtitle: Text(Strings.BACKUP_CLOUD_PROGRESS_DESCRIPTION),
              onTap: () => backupProgression(newContext)
            ),
          ],
        ),
      ),
    );
  }

  wipeLocalProgression(context) {
    showDialog(
      context: context,
      builder: (ctx) =>
        AlertDialog(
          title: Text("Wipe local progress"),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.grey,
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text("Yes, wipe"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                AccountProvider.wipeProgressions().then(
                  (_) =>
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(Strings.WIPE_LOCAL_PROGRESS_SUCCESS), behavior: SnackBarBehavior.floating)
                    ),
                  onError: (e) => 
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(Strings.SOMETHING_WRONG), behavior: SnackBarBehavior.floating)
                    )
                );
              },
            )
          ],
        )
    ).then((val) {
      print(val);
    });
    // Navigator.pop(context);
    // AccountProvider.wipeProgressions().then(
    //   (_) =>
    //     Scaffold.of(context).showSnackBar(
    //       SnackBar(content: Text(Strings.WIPE_LOCAL_PROGRESS_SUCCESS), behavior: SnackBarBehavior.floating)
    //     ),
    //   onError: (e) => 
    //     Scaffold.of(context).showSnackBar(
    //         SnackBar(content: Text(Strings.SOMETHING_WRONG), behavior: SnackBarBehavior.floating)
    //     )
    // );
  }

  backupProgression(BuildContext context) async {
    Navigator.pop(context);
    try {
      if(AccountProvider.user.isLogged) {
        await AccountProvider.backupProgression().then(
          (_) =>
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(Strings.BACKUP_CLOUD_PROGRESS_SUCCESS), behavior: SnackBarBehavior.floating,)
            ),
          onError: (e) =>
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(Strings.SOMETHING_WRONG), behavior: SnackBarBehavior.floating)
            )
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
            child: Text(Strings.ERROR_UNKNOWN),
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
                      title: Text(Strings.ACCOUNT_TITLE, style: TextStyle(fontWeight: FontWeight.bold)),
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
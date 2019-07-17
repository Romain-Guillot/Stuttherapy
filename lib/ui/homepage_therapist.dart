import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/ui/account/account_log_in.dart';
import 'package:stuttherapy/ui/components/auth_buttons.dart';
import 'package:stuttherapy/ui/components/drawer_menu.dart';
import 'package:stuttherapy/ui/components/main_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';

class HomePageTherapist extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: DrawerMenu(context),
      body: AccountProvider.user.isLogged 
        ? loggedMainWidget(context)
        : nonLoggedMainWidget(context)
    );
  }

  Widget nonLoggedMainWidget(context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Please be logged to add patients"),
            AuthButton()
          ],
      ),
    );
  }

  Widget loggedMainWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, Dimen.PADDING, 0, Dimen.PADDING),
          color: Theme.of(context).primaryColor,
          child: ListTile(
            title: Text("ID : ${AccountProvider.user.loggedUser.uid}", style: TextStyle(color: Colors.white),),
            subtitle: Text("Give this ID to your patient so they can add you as therapist.", style: TextStyle(color: Colors.white.withAlpha(150))),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(Dimen.PADDING),
          child: Text("My patients", style: Theme.of(context).textTheme.headline,),
        ),
        ListView.builder(
          padding: const EdgeInsets.all(Dimen.PADDING),
          shrinkWrap: true,
          itemCount: 0,
          itemBuilder: (context, position) => null,
        )
      ],
    );
  }
}
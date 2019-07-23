import 'package:flutter/material.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/components/auth_buttons.dart';
import 'package:stuttherapy/ui/components/drawer_menu.dart';
import 'package:stuttherapy/ui/components/main_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:stuttherapy/ui/therapist/patient_feed.dart';

class HomePageTherapist extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: DrawerMenu(context),
      body: StreamBuilder<Object>(
        stream: AccountProvider.user.loggedUserStream,
        builder: (context, snapshot) =>
          !snapshot.hasData
            ? nonLoggedMainWidget(context)
            : loggedMainWidget(context)
      )
    );
  }

  Widget nonLoggedMainWidget(context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(Strings.HOMEPAGE_THERAPIST_LOGGED_ADD_PATIENT),
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
            subtitle: Text(Strings.HOMEPAGE_THERAPIST_FEED_ID_INFO, style: TextStyle(color: Colors.white.withAlpha(150))),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(Dimen.PADDING),
          child: Text(Strings.HOMEPAGE_THERAPIST_FEED_PATIENTS_TITLE, style: Theme.of(context).textTheme.title,),
        ),
        StreamBuilder(
          stream: (AccountProvider.user as TherapistUser).patients,
          builder: (BuildContext context, AsyncSnapshot<List<LoggedUserMeta>> snapPatients) {
            if(!snapPatients.hasData) {
              return Text(Strings.LOADING);
            } else {
              List<LoggedUserMeta> patients = snapPatients.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: patients.length,
                itemBuilder: (context, position) {
                  LoggedUserMeta patient = patients.elementAt(position);
                  return ListTile(
                    title: Text((patient?.name)??Strings.HOMEPAGE_THERAPIST__FEDD_UNKNOWN_PATIENT_NAME),
                    subtitle: Text(patient.uid),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PatientFeed(patient: patient,)
                      ));
                    },
                  );
                }
              );
            }
          },
        )
        
      ],
    );
  }
}


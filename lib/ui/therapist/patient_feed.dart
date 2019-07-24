import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/components/feed.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';

class PatientFeed extends StatelessWidget {
  final LoggedUserMeta patient;

  PatientFeed({@required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: Strings.THERAPIST_PATIENT_FEED,
        subtitle: patient.name,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).errorColor,
            child: Text(Strings.THERAPIST_PATIENT_FEED_REMOVE),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(Strings.THERAPIST_PATIENT_FEED_REMOVE),
                  content: Text("${Strings.THERAPIST_PATIENT_FEED_REMOVE_INFO} ${patient.name} ?"),
                  actions: <Widget>[
                    FlatButton(
                      textColor: Colors.grey,
                      child: Text(Strings.THERAPIST_PATIENT_FEED_REMOVE_NO),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).errorColor,
                      child: Text(Strings.THERAPIST_PATIENT_FEED_REMOVE_YES),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        AccountProvider.removePatient(patient.uid);
                      },
                    ),
                  ],
                )
              );
            },
          ),
          FeedWidget(
            feed: AccountProvider.getUserFeed(userUID: patient.uid),
          ),
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
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
        title: "Patient feed",
        subtitle: patient.name,
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.comment, color: Colors.white,),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   onPressed: () {
      //     showDialog(context: context, builder: (context)=>SimpleDialog(title: Text("Soon ..."), titlePadding: EdgeInsets.all(20),));
      //   },
      // ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).errorColor,
            child: Text("Remove patient"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Remove the patient ?"),
                  content: Text("Are you sure to remove ${patient.name} ?"),
                  actions: <Widget>[
                    FlatButton(
                      textColor: Colors.grey,
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).errorColor,
                      child: Text("Remove"),
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
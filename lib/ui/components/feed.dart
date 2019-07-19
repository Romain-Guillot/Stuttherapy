import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/ui/components/auth_buttons.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:stuttherapy/ui/exercise/exercise_progression.dart';

class FeedWidget extends StatefulWidget {
  final BehaviorSubject<Feed> feed;

  FeedWidget({@required this.feed});

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoggedUser>(
      stream: AccountProvider.user.loggedUserStream.stream,
      builder: (BuildContext context, AsyncSnapshot<LoggedUser> snapshot) {
        if(!snapshot.hasData || snapshot.data.user == null ) {
          return AuthButton();
        } else {
          return StreamBuilder<Feed>(
            stream: widget.feed.stream,
            builder: (BuildContext context, AsyncSnapshot<Feed> snapshot) {
              if(snapshot.hasError) {
                return ListTile(title:Text("error"));
              }
              if(!snapshot.hasData) {
                return ListTile(title: Text("loading"));
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    therapistInfo(context),
                    SizedBox(height: Dimen.PADDING,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.items.length,
                      itemBuilder: (context, position) {
                        FeedItem item = snapshot.data.items.elementAt(position);
                        switch (item.runtimeType) {
                          case Exercise:
                            return ExerciseProgressionListItem(
                              exercise: item,
                            );
                          default:
                            return ListTile(
                              title: Text(item.label),
                              subtitle: Text(item.toString()),
                            );
                        }
                      },
                    ),
                  ]
                );
              }
            }
          );
        }
      },
    );


  }

  Widget therapistInfo(context) {
    if(AccountProvider.user is StutterUser) {      
      return StreamBuilder<LoggedUserMeta>(
        stream: (AccountProvider.user as StutterUser).therapistStream.stream,
        builder: (context, snapshot) {
          bool therapistExists = snapshot.hasData;
          return Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              title: Text(
                therapistExists? "You have a therapist !" : "You don't have a therapist", 
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                therapistExists ? "id : ${snapshot.data.uid}" : "Ask your therpist his ID.", 
                style: TextStyle(color: Colors.white.withAlpha(150)),
              ),
              trailing: OutlineButton(
                borderSide: BorderSide(color: Colors.white.withAlpha(110)),
                highlightedBorderColor: Colors.white,
                textColor: Colors.white,
                child: Text(
                  therapistExists ? "Revoque" : "Add"
                ), 
                onPressed: () {
                  if(!therapistExists) {
                    showDialogAddTherapist(context);
                  } else {
                    showDialogRevoqueTherapist(context);
                  }
                }
              ),
            )
          );
        }
      );
    } else {
      return SizedBox(); // empty widget
    }
  }

  showDialogAddTherapist(context) {
    showDialog(
      context: context,
      builder: (context) => AddTherapistDialog()
    );
  }

  showDialogRevoqueTherapist(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete your therapist"),
        content: ListView(
          shrinkWrap: true,
          children:<Widget>[
            Text(
              "Therapist will no longer have access to your synchronised exercises.",
              style: TextStyle(color: Colors.black.withAlpha(150)),  
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Theme.of(context).errorColor,
            child: Text("Revoque"),
            onPressed: () {
              Navigator.pop(context);
              AccountProvider.revoqueTherapist();
            },
          )
        ],
      )
    );
  }

}

class AddTherapistDialog extends StatefulWidget {
  @override
  _AddTherapistDialogState createState() => _AddTherapistDialogState();
}

class _AddTherapistDialogState extends State<AddTherapistDialog> {

  final idTherapistController = TextEditingController(text:"2kQc4nXu1OMd8wMmRUHPUbgaOKp2");
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add a therapist"),
        content: ListView(
          shrinkWrap: true,
          children:<Widget>[
            Text(
              "Therapist will have access to your synchronised exercises and will be able to give you feedback about these exercises and share some comments with you.",
              style: TextStyle(color: Colors.black.withAlpha(150)),  
            ),
            SizedBox(height: Dimen.PADDING,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: idTherapistController,
                decoration: InputDecoration(labelText: "Therapist ID"),
                validator: (String value) => value.isEmpty ? "Please provide an ID" : null
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Add"),
            onPressed: () {
              if(_formKey.currentState.validate()) {
                Navigator.pop(context);
                var uid = idTherapistController.text; //temp
                AccountProvider.addTherapist(uid);
              }
              // .then((_) {
              //   // Scaffold.of(context).showSnackBar(
              //   //   SnackBar(content: Text("Therapist add !"), behavior: SnackBarBehavior.floating,)
              //   // );
              // },
              // onError: (_) {
              //   // Scaffold.of(context).showSnackBar(
              //   //   SnackBar(content: Text("Error occured !"), backgroundColor: Theme.of(context).errorColor, behavior: SnackBarBehavior.floating,)
              //   // );
              // });
            },
          )
        ],
      );
  }
}
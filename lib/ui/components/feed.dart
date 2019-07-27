import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/authentification_provider.dart';
import 'package:stuttherapy/strings.dart';
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
                return ListTile(title:Text(Strings.ERROR_UNKNOWN));
              }
              if(!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(Dimen.PADDING),
                  child: Text(Strings.LOADING)
                );
              } else {
                return Column(
                  children: [
                    therapistInfo(context),
                    SizedBox(height: Dimen.PADDING,),
                    ...snapshot.data.items.map((FeedItem item) {
                        switch (item.runtimeType) {
                          case Exercise:
                            return ExerciseProgressionListItem(
                              exercise: item,
                              patientUID: snapshot.data.userUID
                            );
                          default:
                            return ListTile(
                              title: Text(item.label),
                              subtitle: Text(item.toString()),
                            );
                        }
                    }).toList()
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
                therapistExists? Strings.FEED_THERAPIST_EXISTS_INFO : Strings.FEED_THERAPIST_NOT_EXISTS_INFO, 
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                therapistExists ? "id : ${snapshot.data.uid}" : Strings.FEED_ASK_FOR_THERAPIST_ID, 
                style: TextStyle(color: Colors.white.withAlpha(150)),
              ),
              trailing: OutlineButton(
                borderSide: BorderSide(color: Colors.white.withAlpha(110)),
                highlightedBorderColor: Colors.white,
                textColor: Colors.white,
                child: Text(
                  therapistExists ? Strings.FEED_REVOQUE_THERAPIST_BUTTON : Strings.FEED_ADD_THERAPIST_BUTTON
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
        title: Text(Strings.FEED_REVOQUE_THERAPIST_TITLE),
        content: ListView(
          shrinkWrap: true,
          children:<Widget>[
            Text(
              Strings.FEED_REVOQUE_THERAPIST_INFO,
              style: TextStyle(color: Colors.black.withAlpha(150)),  
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Theme.of(context).errorColor,
            child: Text(Strings.FEED_REVOQUE_THERAPIST_BUTTON),
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
        title: Text(Strings.FEED_ADD_THERAPIST_TTTLE),
        content: ListView(
          shrinkWrap: true,
          children:<Widget>[
            Text(
              Strings.FEED_ADD_THERAPIST_INFO,
              style: TextStyle(color: Colors.black.withAlpha(150)),  
            ),
            SizedBox(height: Dimen.PADDING,),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: idTherapistController,
                decoration: InputDecoration(labelText: Strings.FEED_THERAPIST_ID),
                validator: (String value) => value.isEmpty ? Strings.FEED_ADD_THERAPIST_ID_LABEL : null
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(Strings.FEED_ADD_THERAPIST_BUTTON),
            onPressed: () {
              if(_formKey.currentState.validate()) {
                Navigator.pop(context);
                var uid = idTherapistController.text; //temp
                AccountProvider.addTherapist(uid);
              }
            },
          )
        ],
      );
  }
}
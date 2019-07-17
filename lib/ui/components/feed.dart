import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stuttherapy/account/accounts.dart';
import 'package:stuttherapy/account/feed.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/providers/feed_provider.dart';
import 'package:stuttherapy/ui/components/auth_buttons.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:stuttherapy/ui/exercise/exercise_progression.dart';

class FeedWidget extends StatefulWidget {
  final BehaviorSubject<Feed> feed = FeedProvider.feed;

  FeedWidget();

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    if(!AccountProvider.user.isLogged) {
      return AuthButton();
    }
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
              Container(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  title: Text("You have a therapist !", style: TextStyle(color: Colors.white),),
                  subtitle: Text("id : 56556", style: TextStyle(color: Colors.white.withAlpha(150)),),
                  trailing: OutlineButton(
                    borderSide: BorderSide(color: Colors.white.withAlpha(110)),
                    highlightedBorderColor: Colors.white,
                    textColor: Colors.white,
                    child: Text("Revoque"), 
                    onPressed: () {}),
                )
              ),
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
}
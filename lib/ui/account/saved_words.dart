import 'package:flutter/material.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';

class SavedWordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: Strings.SAVED_WORDS_TITLE,
      ),
      body: StreamBuilder<List<String>>(
        stream: AccountProvider.user.savedWords.stream,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapWords) {
          if(!snapWords.hasData)
            return Text(Strings.LOADING);

          return snapWords.data.length == 0
            ? ListTile(
                title: Text(Strings.SAVED_WORDS_EMPTY, 
                style: TextStyle(fontStyle: FontStyle.italic),),
              )
            : ListView(
                children: <Widget>[
                  ListTile(
                    title: RaisedButton(
                      child: Text(Strings.SAVED_WORDS_REMOVE_ALL), 
                      color: Theme.of(context).errorColor,
                      onPressed: () => showAlertWipeSavedWords(context)
                    ),
                  ),
                  ListView.separated(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapWords.data.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      String word = snapWords.data.elementAt(index);
                      return ListTile(
                        title: Text(word),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () => deleteSavedWord(context, word),
                        )
                      );
                    }
                  ),
                ],
              );
        }
      )
    );
  }

  showAlertWipeSavedWords(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text(Strings.SAVED_WORDS_REMOVE_ALL_TITLE),
          content: Text(Strings.SAVED_WORDS_REMOVE_ALL_INFO),
          actions: <Widget>[
            FlatButton(child: Text(Strings.SAVED_WORDS_REMOVE_ALL_NO), textColor: Colors.grey, onPressed: () {
              Navigator.pop(context);
            },),
            FlatButton(child: Text(Strings.SAVED_WORDS_REMOVE_ALL_YES), textColor: Theme.of(context).errorColor, onPressed: () {
              Navigator.pop(context);
              AccountProvider.wipeSavedwords();
            },),
          ],
        )
    ); 
  }

  deleteSavedWord(BuildContext context, String word) {
    AccountProvider.deleteSavedWord(word);
  }
}


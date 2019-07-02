import 'package:flutter/material.dart';
import 'package:stutterapy/providers/account_provider.dart';
import 'package:stutterapy/ui/components/secondary_appbar.dart';

class SavedWordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        context: context,
        title: "Saved words",
      ),
      body: StreamBuilder<List<String>>(
        stream: AccountProvider.user.savedWords.stream,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapWords) {
          if(!snapWords.hasData)
            return Text("Loading...");
        
          return ListView.separated(
            itemCount: snapWords.data.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) =>
              ListTile(
                title: Text(snapWords.data.elementAt(index)),
                trailing: IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () {},
                )
              )
          );
        }
      )
    );
  }
}
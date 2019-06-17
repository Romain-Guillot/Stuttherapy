import 'package:flutter/material.dart';
import 'package:stutterapy/manager.dart';
import 'package:stutterapy/strings.dart';
import 'package:stutterapy/ui/components/drawer_menu.dart';
import 'package:stutterapy/ui/components/exercises_list.dart';
import 'package:stutterapy/ui/components/main_appbar.dart';
import 'package:stutterapy/ui/dimen.dart';



///
///
///
class HomePageStutter extends StatefulWidget {

  final Manager manager;

  HomePageStutter({Key key, @required this.manager}) : super(key: key);

  @override
  _HomePageStutterState createState() => _HomePageStutterState();
}


class _HomePageStutterState extends State<HomePageStutter> {

  List<Widget> pages = [Center(child:CircularProgressIndicator()), Center(child:CircularProgressIndicator())];
  Map<String, Icon> _pagesNavigationIndicator = {Strings.EXERCISES_TITLE : Icon(Icons.home), Strings.FEED : Icon(Icons.feedback)};
  int _selectedPage = 0;


  @override
  void initState() {
    super.initState();
    print("init state");
    pages = [
      ExercisesListView(manager: widget.manager), 
      Text("Feed")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: Text(Strings.APP_NAME),
        user: widget.manager.user,
      ),
      drawer: DrawerMenu(

      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimen.PADDING),
            child: Text(_pagesNavigationIndicator.keys.elementAt(_selectedPage), style: Theme.of(context).textTheme.title),
          ),
          
          Padding(
            padding: const EdgeInsets.all(Dimen.PADDING),
            child: pages.elementAt(_selectedPage),
          ),
          
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _pagesNavigationIndicator.keys.map((String value) {
          return BottomNavigationBarItem(icon: _pagesNavigationIndicator[value], title: Text(value));
        }).toList(),
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ), 
    );
  }
}

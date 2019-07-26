
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as dartColor;
import 'package:intl/intl.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/providers/account_provider.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/components/secondary_appbar.dart';
import 'package:stuttherapy/ui/dimen.dart';
import 'package:stuttherapy/ui/exercise/exercise_progression_item.dart';
import 'package:charts_flutter/flutter.dart';

class BottomNavigationItemRepresentation {
  String label;
  IconData icon;

  BottomNavigationItemRepresentation({@required this.label, @required this.icon});
}


class ExerciseProgressionWidget extends StatefulWidget {

  final ExerciseTheme theme;

  ExerciseProgressionWidget({Key key, @required this.theme}) : assert(theme != null), super(key: key);

  @override
  _ExerciseProgressionWidgetState createState() => _ExerciseProgressionWidgetState();
}



class _ExerciseProgressionWidgetState extends State<ExerciseProgressionWidget> {

  List<BottomNavigationItemRepresentation> pagesTab = [
    BottomNavigationItemRepresentation(label: "Progress", icon: Icons.list), 
    BottomNavigationItemRepresentation(label: "Chart", icon: Icons.show_chart)
  ];

  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: widget.theme.name,
        subtitle: Strings.PROGRESS_TITLE,
        context: context,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: pagesTab.map((BottomNavigationItemRepresentation tab) => 
          BottomNavigationBarItem(
            icon: Icon(tab.icon),
            title: Text(tab.label),
          )
        ).toList(),
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() => _selectedPage = index);
        },
      ),
      body: StreamBuilder(
        stream: AccountProvider.user.progression,
        builder: (BuildContext context, AsyncSnapshot<Map<ExerciseTheme, Map<int, Exercise>>> progressionsSnap) {
          if(!progressionsSnap.hasData || progressionsSnap.data[widget.theme] == null || progressionsSnap.data[widget.theme].length == 0) {
            return ListTile(
              title: Text(Strings.PROGRESS_NO_PROGRESS, style: TextStyle(fontStyle: FontStyle.italic),),
            );
          } else {
            final List<Exercise> progressions = progressionsSnap.data[widget.theme].values.toList();
            progressions.sort();
            switch (_selectedPage) {
              case 0: return ProgressionList(theme: widget.theme, progressions: progressions,);
              case 1: return ProgressChart(progress: progressions,);
              default: return Text(Strings.ERROR_UNKNOWN);
            }
          }
        },
      )
    );
  }
}

class ProgressionList extends StatelessWidget {

  final ExerciseTheme theme;
  final List<Exercise> progressions;

  ProgressionList({Key key, @required this.theme, @required this.progressions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: progressions.length,
      itemBuilder: (BuildContext ctx, int position) 
        => ExerciseProgressionListItem(exercise: progressions.elementAt(position), patientUID: AccountProvider.user?.loggedUser?.uid,),
    );
  }
}


class ExerciseProgressionListItem extends StatelessWidget {
  final Exercise exercise;
  final String patientUID;

  ExerciseProgressionListItem({Key key, @required this.exercise, @required this.patientUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.theme.name),
      subtitle: Text(exercise.date.toString()),
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (context) => ExerciseProgressionItemWidget(exercise: exercise, patientUID: patientUID)
      )),
    );
  }
}


class ProgressChart extends StatefulWidget {

  final List<Exercise> progress;

  ProgressChart({Key key, @required this.progress}) : super(key: key);


  @override
  _ProgressChartState createState() => _ProgressChartState();

}


class _ProgressChartState extends State<ProgressChart> {
  List<TimeSeriesProgress> data = [];
  List<Series<TimeSeriesProgress, int>> series;
  Color lineColor = MaterialPalette.transparent; // loading color before to set the real color in build ...
  ChartWindowTime selectedWindowTime = ChartWindowTime.WEEK;
  final DateFormat format = DateFormat('MMMM d, y');

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    dartColor.Color color = Theme.of(context).accentColor;
    lineColor = Color(r: color.red, g: color.green, b: color.blue);
    return 
     Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Dimen.PADDING),
            child: Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text("Window time: "),
                DropdownButton(
                  items: ChartWindowTime.values.map((ChartWindowTime value) =>
                    DropdownMenuItem(
                      child: Text(value.toString()),
                      value: value,
                    )
                  ).toList(),
                  value: selectedWindowTime,
                  onChanged: (ChartWindowTime value) {
                    setState(() {
                      selectedWindowTime = value;
                      setData();
                    });
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
             child: LineChart(
              series,
              animate: true,
              // dateTimeFactory: const LocalDateTimeFactory(),
              behaviors: [
                ChartTitle(
                  "Pronunciation accuracy (%)", 
                  behaviorPosition: BehaviorPosition.start
                ),
                ChartTitle(
                  "From ${format.format(historyLimit())} to ${format.format(DateTime.now())}", 
                  behaviorPosition: BehaviorPosition.bottom,
                  titleStyleSpec: TextStyleSpec(fontSize: 14)
                ),
                PanAndZoomBehavior(),
              ],
              domainAxis: AxisSpec<num>(showAxisLine: false, renderSpec: NoneRenderSpec()),
              primaryMeasureAxis: new NumericAxisSpec(
                viewport: NumericExtents(0,100),)
            )
          )
        ],
    );
  }

  setData() {
    data = [];
    series = [];

    DateTime previousLimit = historyLimit();

    List<Exercise> tmp = [
      Exercise(resources: null, theme: null, wordsCheckingEnable: true, createdAt: DateTime(2019,01,20))
      ..numberOfWords = 5,
      ...widget.progress,
    ];

    tmp.sort();
    tmp = tmp.reversed.toList();
    
    var index = 0;
    for(Exercise ex in tmp) {
      double ratio = ex.getProgressRatio();
      if(ratio != null && ex.date.date.isAfter(previousLimit)) {
        data.add(TimeSeriesProgress(index: index, ratio: ratio));
        index++;
      }
    }
    
    series = [Series<TimeSeriesProgress, int>(
      id: "Pronunciation accuracy",
      colorFn: (_, __) => lineColor,
      measureFn: (TimeSeriesProgress progress, _) => progress.ratio,
      domainFn: (TimeSeriesProgress progress, _) => progress.index,
      data: data,
    )];
  }

  DateTime historyLimit() {
    return DateTime.now().subtract(Duration(days:selectedWindowTime.nbDay));
  }
}

/// Sample time series data type.
class TimeSeriesProgress {
  final int index;
  final double ratio;

  TimeSeriesProgress({@required this.index, @required this.ratio});
}

class ChartWindowTime {
  static const MONTH = const ChartWindowTime._("Month", 30);
  static const WEEK = const ChartWindowTime._("Week", 7);
  static const YEAR = const ChartWindowTime._("Year", 365);

  static List<ChartWindowTime> get values => [WEEK, MONTH, YEAR];

  final String name;
  final int nbDay;

  const ChartWindowTime._(this.name, this.nbDay);

  @override
  String toString() => name;

  

}
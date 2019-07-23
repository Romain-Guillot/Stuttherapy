import 'package:logger/logger.dart';

/// Custom [LogPrinter] to print logs on a single line
/// (except for exception and stacktrace)
class MyPrinter extends LogPrinter {

  final String name;
  MyPrinter(this.name);

  @override
  void log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];
    println(color('$emoji $name - ${event.message}'));
    if(event.error != null)
      println(color(event.error.toString()));
    if(event.stackTrace != null) 
      for (var line in event.stackTrace.toString().split('\n').sublist(0, 5)) {
        println(color('$line'));
      }
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/ui/features/create_task/CreateTaskScreen.dart';
import 'package:kotak_cherry/ui/features/task_list/TaskListScreen.dart';

mixin RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("generateRoute");
    switch (Uri.parse(settings.name!).path) {
      case '/':
        // return MaterialPageRoute<CreateTaskScreen>(builder: (_) => CreateTaskScreen());
        return MaterialPageRoute<TaskListScreen>(builder: (_) => TaskListScreen());

      case '/tasklist':
        return MaterialPageRoute<TaskListScreen>(builder: (_) => TaskListScreen());

        return MaterialPageRoute<TaskListScreen>(
            settings: RouteSettings(name: "/tasklist?refresh=${getArgumentValue('refresh', settings)}"),
            builder: (_) => TaskListScreen.fromOptions(refresh: int.parse(getArgumentValue('refresh', settings))));

      case '/createtask':
        // return MaterialPageRoute<CreateTaskScreen>(builder: (_) => CreateTaskScreen());
        return MaterialPageRoute<CreateTaskScreen>(builder: (_) => CreateTaskScreen());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static String getArgumentValue(String name, RouteSettings settings) {
    var map = Uri.parse(settings.name!).queryParameters;
    final args = settings.arguments != null ? settings.arguments as Map : null;

    if (map != null && map.isNotEmpty) return map[name].toString();
    if (args != null && args.isNotEmpty) return args[name].toString();

    return "";
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<Widget>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

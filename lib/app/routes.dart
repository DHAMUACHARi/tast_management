import 'package:flutter/material.dart';
import 'package:task_management_app/app/ui/screens/TaskDetailScreen.dart';
import 'ui/screens/home_screen.dart';

class Routes {
  static const String home = '/home';
  static const String taskDetail = '/task-detail';
  static const String settings = '/settings';

  static Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => HomeScreen(),
    taskDetail: (context) => TaskDetailScreen(),
  };
}

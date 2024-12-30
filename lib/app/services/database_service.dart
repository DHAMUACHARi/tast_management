import 'package:hive/hive.dart';

import '../models/task_model.dart';

class DatabaseService {
  static Box<Task>? _taskBox;

  // Initialize the database
  static Future<void> init() async {
    _taskBox = await Hive.openBox<Task>('taskBox');
    print("Database initialized");
  }

  static Future<void> addTask(Task task) async {
    await _taskBox?.add(task);
    print("Task added to database: $task");
  }

  static Future<void> updateTask(int index, Task task) async {
    await _taskBox?.putAt(index, task);
    print("Task updated in database: $task");
  }


  static Future<void> deleteTask(int index) async {
    await _taskBox?.deleteAt(index);
    print("Task deleted from database at index $index");
  }

  static List<Task> getTasks() {
    List<Task> taskList = _taskBox?.values.toList() ?? [];
    print("Fetched tasks from database: $taskList");
    return taskList;
  }
}

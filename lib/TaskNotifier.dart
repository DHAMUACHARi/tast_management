import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/models/task_model.dart';
import 'app/services/database_service.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  void _loadTasks() {
    state = DatabaseService.getTasks();
  }

  void addTask(Task task) {
    DatabaseService.addTask(task);
    _loadTasks();
  }


  void updateTask(int index, Task task) {
    DatabaseService.updateTask(index, task);
    _loadTasks();
  }

  void deleteTask(int index) {
    DatabaseService.deleteTask(index);
    _loadTasks();
  }


  void toggleTaskStatus(int index) {
    Task updatedTask = state[index];
    updatedTask.isCompleted = !updatedTask.isCompleted;
    updateTask(index, updatedTask);
  }
}


final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

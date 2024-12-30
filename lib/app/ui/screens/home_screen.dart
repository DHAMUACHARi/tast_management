import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../TaskNotifier.dart';
import '../../models/task_model.dart';
import '../notification_helper.dart';
import '../widgets/task_card.dart';
import '../widgets/theme_switch.dart';

// The TaskNotifier provider
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addTask(String title, String description, DateTime? reminderTime) {
    final task = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
    );
    ref.read(taskProvider.notifier).addTask(task);
    if (reminderTime != null) {
      NotificationHelper.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Task Reminder',
        body: title,
        scheduledTime: reminderTime,
      );
    }
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDateTime;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                style: TextStyle(fontSize: 16),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                  }
                },
                child: Text('Set Reminder'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  _addTask(titleController.text, descriptionController.text, selectedDateTime);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Both fields are required!'),
                  ));
                }
              },
              child: Text('Add Task'),
            ),
          ],
        );
      },
    );
  }


  void _showEditTaskDialog(int index) {
    final titleController = TextEditingController(text: ref.read(taskProvider)[index].title);
    final descriptionController = TextEditingController(text: ref.read(taskProvider)[index].description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Edit Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                style: TextStyle(fontSize: 16),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  Task updatedTask = ref.read(taskProvider)[index];
                  updatedTask.title = titleController.text;
                  updatedTask.description = descriptionController.text;
                  ref.read(taskProvider.notifier).updateTask(index, updatedTask);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Both fields are required!'),
                  ));
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }


  void _deleteTask(int index) {
    ref.read(taskProvider.notifier).deleteTask(index);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    List<Task> filteredTasks = tasks.where((task) {
      final matchesQuery = task.title.toLowerCase().contains(_searchQuery) ||
          task.description.toLowerCase().contains(_searchQuery);
      if (_currentIndex == 0) {
        return !task.isCompleted && matchesQuery;
      } else {
        return task.isCompleted && matchesQuery;
      }
    }).toList();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          ThemeSwitch(),
        ],
      ),
      body: filteredTasks.isEmpty
          ? Center(
        child: Text(
          _currentIndex == 0
              ? 'No active tasks yet. Add a new task!'
              : 'No completed tasks yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredTasks.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: TaskCard(
              onTap: () {
                Navigator.pushNamed(context, '/task-detail',
                    arguments: filteredTasks[index]);
              },
              task: filteredTasks[index],
              index: index,
              onToggleStatus: (index) => ref.read(taskProvider.notifier).toggleTaskStatus(index),
              onEdit: (index) => _showEditTaskDialog(index),
              onDelete: (index) => _deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}

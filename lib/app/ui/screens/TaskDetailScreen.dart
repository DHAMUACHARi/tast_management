import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Task task = ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(task.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(task.title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(task.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16.0),
            Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8.0),
            Text(
              task.isCompleted ? 'Completed' : 'Pending',
              style: TextStyle(
                fontSize: 16,
                color: task.isCompleted ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

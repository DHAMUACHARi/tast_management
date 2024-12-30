import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int index;
  final Function(int) onToggleStatus;
  final Function(int) onEdit;
  final Function(int) onDelete;
  final VoidCallback onTap;

  TaskCard({
    required this.task,
    required this.index,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        onTap: onTap,
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: () => onToggleStatus(index),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(index),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(index),
            ),
          ],
        ),
      ),
    );
  }
}

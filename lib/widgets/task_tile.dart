import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onEdit,
  });

  Color getPriorityColor() {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: getPriorityColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.task,
            color: getPriorityColor(),
            size: 30,
          ),
        ),
        title: Text(
          task.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.deepPurple[900],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple[400]),
              SizedBox(width: 6),
              Text(
                task.dueDate.toLocal().toString().split(' ')[0],
                style: TextStyle(color: Colors.deepPurple[400], fontSize: 14),
              ),
              SizedBox(width: 16),
              Icon(Icons.priority_high, size: 16, color: getPriorityColor()),
              SizedBox(width: 6),
              Text(
                task.priority,
                style: TextStyle(color: getPriorityColor(), fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.deepPurple),
          onPressed: onEdit,
          splashRadius: 24,
          tooltip: 'Edit Task',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../db/task_database.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  void _delete(BuildContext context) async {
    await TaskDatabase.instance.deleteTask(task.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Task Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.name,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text("Due Date:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple)),
                SizedBox(width: 8),
                Text(
                  task.dueDate.toLocal().toString().split(' ')[0],
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.priority_high, color: Colors.deepPurple),
                SizedBox(width: 10),
                Text("Priority:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple)),
                SizedBox(width: 8),
                Text(task.priority, style: TextStyle(fontSize: 18)),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _delete(context),
                icon: Icon(Icons.delete),
                label: Text("Delete Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

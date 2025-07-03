import 'package:flutter/material.dart';
import '../models/task.dart';
import '../db/task_database.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _nameController;
  late DateTime _dueDate;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  void _submit() async {
    final updatedTask = widget.task.copyWith(
      name: _nameController.text,
      dueDate: _dueDate,
      priority: _priority,
    );
    await TaskDatabase.instance.updateTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Edit Task", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Make changes to your task",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Task Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.task_alt, color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.deepPurple),
                  color: Colors.deepPurple[50],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.deepPurple),
                    SizedBox(width: 10),
                    Text(
                      "Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: _pickDate,
                      child: Text(
                        "Change",
                        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            DropdownButtonFormField<String>(
              value: _priority,
              items: ['Low', 'Medium', 'High']
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              )
                  .toList(),
              onChanged: (val) => setState(() => _priority = val!),
              decoration: InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.priority_high, color: Colors.deepPurple),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Save Changes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

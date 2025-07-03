import 'package:flutter/material.dart';
import '../db/task_database.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime? _dueDate;
  String _priority = 'Low';

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please select a due date")));
        return;
      }
      final task = Task(name: _name, dueDate: _dueDate!, priority: _priority);
      await TaskDatabase.instance.insertTask(task);
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Add New Task", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Let's get organized!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Task Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.task_alt, color: Colors.deepPurple),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Task name can't be empty" : null,
                onChanged: (val) => _name = val,
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
                    color: _dueDate == null ? Colors.transparent : Colors.deepPurple[50],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Text(
                        _dueDate == null
                            ? "Choose Due Date"
                            : "Due Date: ${_dueDate!.toLocal().toString().split(' ')[0]}",
                        style: TextStyle(
                          fontSize: 16,
                          color: _dueDate == null ? Colors.grey : Colors.deepPurple,
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
                  "Save Task",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

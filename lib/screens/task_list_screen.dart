import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/task_database.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'task_details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  String? sortBy;
  String quote = "";

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadSortPreference();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    final url = Uri.parse("https://zenquotes.io/api/random");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quote = data[0]['q'] + " — " + data[0]['a'];
      });
    }
  }

  Future<void> _loadTasks() async {
    final dbTasks = await TaskDatabase.instance.getTasks();
    setState(() => tasks = dbTasks);
  }

  Future<void> _loadSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    sortBy = prefs.getString('sortBy') ?? 'date';
    _applySort();
  }

  void _applySort() {
    setState(() {
      if (sortBy == 'date') {
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      } else {
        final priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3};
        tasks.sort((a, b) =>
            priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!));
      }
    });
  }

  void _updateSortPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', value);
    setState(() {
      sortBy = value;
    });
    _applySort();
  }

  void _deleteTask(Task task) async {
    await TaskDatabase.instance.deleteTask(task.id!);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Task Manager", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _updateSortPreference(value),
            icon: Icon(Icons.sort, color: Colors.white,),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'date', child: Text("Sort by Date")),
              PopupMenuItem(value: 'priority', child: Text("Sort by Priority")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (quote.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                quote,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
              child: Text(
                "No tasks available.\nTap '+' to add your first task!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteTask(task),
                  child: TaskTile(
                    task: task,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(task: task),
                      ),
                    ).then((_) => _loadTasks()),
                    onEdit: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTaskScreen(task: task),
                      ),
                    ).then((_) => _loadTasks()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 32, color: Colors.white,),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddTaskScreen()),
        ).then((_) => _loadTasks()),
      ),
    );
  }
}

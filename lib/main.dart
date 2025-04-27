// lib/main.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatefulWidget {
  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = false;

  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      tasks = await apiService.fetchTasks();
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createTask() async {
    if (taskController.text.isEmpty) return;

    try {
      await apiService.createTask(taskController.text);
      taskController.clear();
      await _fetchTasks();
    } catch (e) {
      print('Error creating task: $e');
    }
  }

  Future<void> _updateTask(int taskId, String status) async {
    try {
      await apiService.updateTask(taskId, status);
      await _fetchTasks();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task List'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: InputDecoration(
                              labelText: 'Task Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _createTask,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(task['title']),
                            subtitle: Text('Status: ${task['status']}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (status) {
                                _updateTask(task['id'], status);
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'done',
                                  child: Text('Mark as Done'),
                                ),
                                PopupMenuItem(
                                  value: 'pending',
                                  child: Text('Mark as Pending'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

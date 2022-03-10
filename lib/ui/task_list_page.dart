import 'package:flutter/material.dart';
import 'package:score_more/data/task.dart';
import 'package:score_more/data/task_repository.dart';
import 'package:score_more/ui/add_task_page.dart';

class TaskListPage extends StatefulWidget {
  @override
  State<TaskListPage> createState() => _TaskListState();
}

class _TaskListState extends State<TaskListPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    refreshTasks();
  }

  void refreshTasks() async {
    final tasks = await TaskRepository.INSTANCE.getTasks();
    setState(() {
      this.tasks = tasks;
    });
  }

  void updateTask(Task task) async {
    final success = await TaskRepository.INSTANCE.updateTask(task);
    setState(() {
      if (success) {
        refreshTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = tasks[index];
              return Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Checkbox(
                        value: task.isComplete,
                        onChanged: (value) {
                          final updated = Task(
                              task.id, task.title, task.score, value ?? false);
                          updateTask(updated);
                        }),
                    Text(task.title,
                        style: TextStyle(
                            decoration: task.isComplete
                                ? TextDecoration.lineThrough
                                : TextDecoration.none)),
                    const Spacer(),
                    Text(task.score.toString())
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          ).then((value) => {refreshTasks()});
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

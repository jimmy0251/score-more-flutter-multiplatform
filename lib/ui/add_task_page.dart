import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_more/data/task.dart';
import 'package:score_more/data/task_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final scoreController = TextEditingController(text: "1");

  Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
  }

  void addTask() async {
    final success = await TaskRepository.INSTANCE.addTask(Task(
        uuid.v4(),
        titleController.text,
        num.tryParse(scoreController.text)?.toInt() ?? 1,
        false));
    setState(() {
      if (success) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
                hintText: 'Enter todo item',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextFormField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Score",
                    hintText: "Score",
                  )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTask();
        },
        tooltip: 'Add',
        child: const Icon(Icons.check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

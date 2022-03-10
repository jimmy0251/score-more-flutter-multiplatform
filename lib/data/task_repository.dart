
import 'dart:ffi';

import 'package:score_more/data/task.dart';

class TaskRepository {
  static final TaskRepository INSTANCE = TaskRepository();

  List<Task> tasks = [];

  Future<List<Task>> getTasks() {
    return Future.value(tasks);
  }

  Future<bool> addTask(Task task) {
    tasks.insert(0, task);
    sortTasks();
    return Future.value(true);
  }

  Future<bool> removeTask(Task task) {
    tasks.remove(task);
    sortTasks();
    return Future.value(true);
  }

  Future<bool> updateTask(Task task) {
    final index = tasks.indexWhere((element) => element.id == task.id);
    if(index != -1) {
      tasks[index] = task;
    }
    sortTasks();
    return Future.value(true);
  }

  void sortTasks() {
    tasks.sort((a, b) {
      if(a.isComplete == b.isComplete) {
        return 0;
      }

      if(a.isComplete) {
        return 1;
      }
      if(b.isComplete) {
        return -1;
      }
     return 0;
    });
  }

}
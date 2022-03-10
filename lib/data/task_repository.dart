import 'dart:ffi';

import 'package:score_more/data/task.dart';
import 'package:sqflite/sqflite.dart';

final String tableTodo = 'todo';

final String columnId = '_id';
final String columnTitle = 'title';
final String columnComplete = 'complete';
final String columnScore = 'score';

class TaskRepository {
  static final TaskRepository INSTANCE = TaskRepository();

  Database? _db;

  Future<Database> getDB() async {
    final db = _db;
    if(db != null) {
      return db;
    }
    return await openDatabase("todo.db", version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''create table $tableTodo (
          $columnId text primary key, 
          $columnTitle text not null,
          $columnComplete integer not null,
          $columnScore integer not null)
          ''');
    });
  }

  Future<List<Task>> getTasks() async {
    final db = await getDB();
    List<Map<String, Object?>> maps = await db.query(tableTodo,
        columns: [columnId, columnComplete, columnTitle, columnScore]);

    final tasks = maps.map((e) => Task.fromMap(e)).toList(growable: false);
    sortTasks(tasks);
    return tasks;
  }

  Future<bool> addTask(Task task) async {
    final db = await getDB();
    return db.insert(tableTodo, task.toMap()).then((value) => value != 0);
  }

  Future<bool> removeTask(Task task) async {
    final db = await getDB();
    return db.delete(tableTodo,
        where: '$columnId = ?',
        whereArgs: [task.id]).then((value) => value == 1);
  }

  Future<bool> updateTask(Task task) async {
    final db = await getDB();
    return db.update(tableTodo, task.toMap(),
        where: '$columnId = ?',
        whereArgs: [task.id]).then((value) => value == 1);
  }

  void sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if (a.isComplete == b.isComplete) {
        return 0;
      }

      if (a.isComplete) {
        return 1;
      }
      if (b.isComplete) {
        return -1;
      }
      return 0;
    });
  }
}

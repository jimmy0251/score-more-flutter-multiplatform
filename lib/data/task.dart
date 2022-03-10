
import 'package:score_more/data/task_repository.dart';

class Task {
  final String id;
  final String title;
  final int score;
  final bool isComplete;

  Task(this.id, this.title, this.score, this.isComplete);

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnComplete: isComplete == true ? 1 : 0,
      columnId: id,
      columnScore: score
    };
    return map;
  }

  static Task fromMap(Map<String, Object?> map) {
    final id = map[columnId].toString();
    final title = map[columnTitle].toString();
    final score = num.tryParse(map[columnScore].toString())?.toInt() ?? 0;
    final isComplete = map[columnComplete] == 1;
    return Task(id, title, score, isComplete);
  }
}
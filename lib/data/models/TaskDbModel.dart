import 'package:hive/hive.dart';

part 'TaskDbModel.g.dart';

@HiveType(typeId: 1)
class TaskDbModel extends HiveObject {
  @HiveField(0)
  String task_id = "";
  @HiveField(1)
  int task_priority = -1;
  @HiveField(2)
  int task_label = -1;
  @HiveField(3)
  String title = "";
  @HiveField(4)
  String description = "";
  @HiveField(5)
  String due_date = "";
  @HiveField(6)
  int is_completed = -1;

  Map<String, dynamic> toMap() {
    return {
      'id': task_id,
      'title': title,
      'due_date': due_date,
      'description': description,
      'task_priority': task_priority,
      'task_label': task_label
    };
  }

  TaskDbModel(this.description,
      {required this.task_id, required this.task_priority, this.is_completed = 0, required this.due_date, required this.title, required this.task_label});

  factory TaskDbModel.fromMap(Map<String, dynamic> map) {
    return TaskDbModel("",
        task_id: map['id'].toString(),
        task_priority: map['task_priority'],
        task_label: map['task_label'],
        due_date: map['due_date'],
        title: map['title'], is_completed: map['is_completed']);
  }
}

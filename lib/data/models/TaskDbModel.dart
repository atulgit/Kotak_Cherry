import 'package:hive/hive.dart';

class TaskDbModel {
  String task_id = "";
  int task_priority = -1;
  int task_label = -1;
  String title = "";
  String description = "";
  String due_date = "";

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
      {required this.task_id, required this.task_priority, required this.due_date, required this.title, required this.task_label});

  factory TaskDbModel.fromMap(Map<String, dynamic> map) {
    return TaskDbModel("",
        task_id: map['id'].toString(),
        task_priority: map['task_priority'],
        task_label: map['task_label'],
        due_date: map['due_date'],
        title: map['title']);
  }
}

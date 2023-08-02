import 'package:kotak_cherry/entity/BaseEntity.dart';

class TaskEntity extends BaseEntity implements Comparable<TaskEntity> {
  int taskId = -1;
  int taskPriority = -1;
  int taskLabel = -1;
  int isCompleted = -1; //0 -> Not-Completed, 1-> Completed

  String title = "";
  String description = "";
  String dueDate = "";

  TaskEntity();

  TaskEntity.fromAttr(this.taskId, this.title, this.dueDate, this.taskPriority, this.taskLabel, this.description, {this.isCompleted = 0});

  TaskEntity.fromId(this.taskId);

  @override
  int compareTo(TaskEntity other) {
    if (taskPriority < other.taskPriority) {
      return -1;
    } else if (taskPriority > other.taskPriority) {
      return 1;
    } else {
      return 0;
    }
  }

  int compareByTaskId(TaskEntity other) {
    if (taskId < other.taskId) {
      return 1;
    } else if (taskId > other.taskId) {
      return -1;
    } else {
      return 0;
    }
  }

  int compareByPriority(TaskEntity other) {
    if (taskPriority < other.taskPriority) {
      return -1;
    } else if (taskPriority > other.taskPriority) {
      return 1;
    } else {
      return 0;
    }
  }

  int compareByDate(TaskEntity other) {
    if (DateTime.parse(dueDate).isAfter(DateTime.parse(other.dueDate))) {
      return 1;
    } else if (DateTime.parse(dueDate).isBefore(DateTime.parse(other.dueDate))) {
      return -1;
    } else {
      return 0;
    }
  }
}

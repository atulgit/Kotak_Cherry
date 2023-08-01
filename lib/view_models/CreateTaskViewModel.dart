import 'package:flutter/material.dart';
import 'package:kotak_cherry/view_models/BaseViewModel.dart';

import '../common/KotalResult.dart';
import '../data/RepoImp/TaskRepoImp.dart';
import '../domain/user_cases/SaveTaskUseCase.dart';
import '../entity/AttachmentEntity.dart';
import '../entity/TaskEntity.dart';

class CreateTaskViewModel extends BaseViewModel {
  int taskId = -1;
  int priority = -1;
  int label = -1;
  String dueDate = "";
  String title = "";
  String description = "";
  TimeOfDay? notificationTime;

  List<TaskAttachmentEntity> attachments = [];

  void setNotificationTime(TimeOfDay timeOfDay) {
    notificationTime = timeOfDay;
    notifyListeners();
  }

  Future<void> saveTask() async {
    var taskUseCase = SaveTaskUseCase();
    var task = TaskEntity();
    task.taskId = 100;
    task.title = title;
    task.taskPriority = priority;
    task.taskLabel = label;
    task.dueDate = dueDate;
    task.isCompleted = -1;

    var taskUseCaseParam = SaveTaskUseCaseParams(task, attachments: attachments);
    var result = await taskUseCase.invoke(taskUseCaseParam);
    switch (result) {
      case Success<TaskEntity>():
        // (result as Success<TaskEntity>).value.id;
        break;

      case Failure<TaskEntity>():
      // TODO: Handle this case.
    }

    notifyListeners();
  }
}

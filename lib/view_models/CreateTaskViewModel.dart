import 'package:flutter/material.dart';
import 'package:kotak_cherry/view_models/BaseViewModel.dart';

import '../common/KCResult.dart';
import '../data/RepoImp/TaskRepoImp.dart';
import '../domain/user_cases/SaveTaskUseCase.dart';
import '../entity/AttachmentEntity.dart';
import '../entity/TaskEntity.dart';
import '../ui/common/AppConstants.dart';

class CreateTaskViewModel extends BaseViewModel {
  int taskId = -1;
  int priority = -1;
  int label = -1;
  String dueDate = "";
  String title = "";
  String description = "";
  TimeOfDay? notificationTime;

  final ValueNotifier<String> errorListener = ValueNotifier<String>('');

  final List<TaskAttachmentEntity> _attachments = [];

  void setNotificationTime(TimeOfDay timeOfDay) {
    notificationTime = timeOfDay;
    notifyListeners();
  }

  void addAttachment(TaskAttachmentEntity attachmentEntity) {
    _attachments.add(attachmentEntity);
  }

  Future<void> saveTask() async {
    var taskUseCase = SaveTaskUseCase();
    var task = TaskEntity();
    task.taskId = 100;
    task.title = title;
    task.taskPriority = priority;
    task.description = description;
    task.taskLabel = label;
    task.dueDate = dueDate;
    task.isCompleted = -1;

    var taskUseCaseParam = SaveTaskUseCaseParams(task, attachments: _attachments);
    var result = await taskUseCase.invoke(taskUseCaseParam);
    switch (result) {
      case Success<TaskEntity>():
        // (result as Success<TaskEntity>).value.id;
        break;

      case Failure<TaskEntity>():
        errorListener.value = AppConstants.ERROR_MESSAGE;
        notifyListeners();
        break;
    }

    notifyListeners();
  }
}

import 'package:kotak_cherry/common/KCResult.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/TaskAttachmentDbModel.dart';
import 'package:kotak_cherry/data/models/TaskDbModel.dart';
import 'package:kotak_cherry/data/respository/TaskRespositoryDatabase.dart';
import 'package:kotak_cherry/entity/AttachmentEntity.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

class TaskDatabaseRepoImp implements TaskRepositoryDatabase {
  final DatabaseService _dbService = DatabaseService(); //Singleton instance.

  @override
  Future<Result<List<TaskEntity>>> fetchTaskList() async {
    var taskModel = await _dbService.fetchTaskList();

    switch (taskModel) {
      case Success<List<TaskDbModel>>():
        var tasks = taskModel.value.map((e) {
          return _mapToTaskEntity(e);
        });

        return Success(tasks.toList());

      case Failure<List<TaskDbModel>>():
        return const Failure();
    }
  }

  TaskEntity _mapToTaskEntity(TaskDbModel taskDbModel) {
    return TaskEntity.fromAttr(
        taskDbModel.key, taskDbModel.title, taskDbModel.due_date, taskDbModel.task_priority, taskDbModel.task_label, taskDbModel.description,
        isCompleted: taskDbModel.is_completed);
  }

  TaskDbModel _mapToTaskModel(TaskEntity taskEntity) {
    return TaskDbModel(taskEntity.description,
        task_label: taskEntity.taskLabel,
        task_priority: taskEntity.taskPriority,
        task_id: taskEntity.taskId.toString(),
        due_date: taskEntity.dueDate,
        title: taskEntity.title,
        is_completed: taskEntity.isCompleted);
  }

  TaskAttachmentDbModel _mapToTaskAttachmentModel(TaskAttachmentEntity taskEntity) {
    return TaskAttachmentDbModel(taskEntity.taskId, taskEntity.name, taskEntity.attachmentId, taskEntity.url, taskEntity.type);
  }

  // @override
  // Future<Result<TaskEntity>> fetchTask(int id) async {
  //   var taskModel = await DatabaseService.saveTask(_mapToTaskModel(taskEntity));
  //   switch (taskModel) {
  //     case Success<TaskDbModel>():
  //       return Success(_mapToTaskEntity(taskModel.value));
  //
  //     case Failure<TaskDbModel>():
  //       return const Failure();
  //   }
  // }

  @override
  Future<Result<TaskEntity>> saveTask(TaskEntity taskEntity) async {
    var taskModel = await _dbService.saveTask(_mapToTaskModel(taskEntity));
    switch (taskModel) {
      case Success<TaskDbModel>():
        return Success(_mapToTaskEntity(taskModel.value));

      case Failure<TaskDbModel>():
        return const Failure();
    }
  }

  @override
  Future<Result<TaskEntity>> fetchTask(String id) async {
    var taskModel = await _dbService.fetchTask(id);
    switch (taskModel) {
      case Success<TaskDbModel>():
        return Success(_mapToTaskEntity(taskModel.value));

      case Failure<TaskDbModel>():
        return const Failure();
    }
  }

  @override
  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query) async {
    var taskModel = await _dbService.fetchSortedAndFilteredTask(priority, label, dueDate, sortBy, query);
    switch (taskModel) {
      case Success<List<TaskDbModel>>():
        var tasks = taskModel.value.map((e) {
          return _mapToTaskEntity(e);
        });

        return Success(tasks.toList());

      case Failure<List<TaskDbModel>>():
        return const Failure();
    }
  }

  @override
  Future<Result<TaskEntity>> setCompletedTask(int taskId) async {
    var taskModel = await _dbService.setCompletedTask(taskId);
    switch (taskModel) {
      case Success<TaskDbModel>():
        return Success(_mapToTaskEntity(taskModel.value));

      case Failure<TaskDbModel>():
        return const Failure();
    }
  }

  @override
  Future<Result> saveAttachments(List<TaskAttachmentEntity> attachments) async {
    List<TaskAttachmentDbModel> attachmentDbList = [];
    attachments.map((e) {
      attachmentDbList.add(_mapToTaskAttachmentModel(e));
    });

    var result = await _dbService.saveAttachments(attachmentDbList);
    switch (result) {
      case Success<void>():
        return Success<void>(result.value);

      case Failure<void>():
        return const Failure();
    }
  }
}

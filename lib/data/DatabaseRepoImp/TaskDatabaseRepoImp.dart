import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/TaskDbModel.dart';
import 'package:kotak_cherry/data/respository/TaskRespositoryDatabase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

class TaskDatabaseRepoImp implements TaskRepositoryDatabase {
  // DatabaseService? dbService;

  @override
  Future<Result<List<TaskEntity>>> fetchTaskList() async {
    var taskModel = await DatabaseService.fetchTaskList();

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
        -1, taskDbModel.title, taskDbModel.due_date, taskDbModel.task_priority, taskDbModel.task_label, taskDbModel.description);
  }

  TaskDbModel _mapToTaskModel(TaskEntity taskEntity) {
    return TaskDbModel(taskEntity.description,
        task_label: taskEntity.taskLabel,
        task_priority: taskEntity.taskPriority,
        task_id: taskEntity.taskId.toString(),
        due_date: taskEntity.dueDate,
        title: taskEntity.title);
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
    var taskModel = await DatabaseService.saveTask(_mapToTaskModel(taskEntity));
    switch (taskModel) {
      case Success<TaskDbModel>():
        return Success(_mapToTaskEntity(taskModel.value));

      case Failure<TaskDbModel>():
        return const Failure();
    }
  }

  @override
  Future<Result<TaskEntity>> fetchTask(String id) async {
    var taskModel = await DatabaseService.fetchTask(id);
    switch (taskModel) {
      case Success<TaskDbModel>():
        return Success(_mapToTaskEntity(taskModel.value));

      case Failure<TaskDbModel>():
        return const Failure();
    }
  }

  @override
  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy) async {
    var taskModel = await DatabaseService.fetchSortedAndFilteredTask(priority, label, dueDate, sortBy);
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
}

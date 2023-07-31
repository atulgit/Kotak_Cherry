import 'package:kotak_cherry/common/KotalResult.dart';

import '../../entity/TaskEntity.dart';

abstract interface class TaskRepositoryDatabase {
  Future<Result<TaskEntity>> fetchTask(String id);

  Future<Result<TaskEntity>> saveTask(TaskEntity taskEntity);

  Future<Result<List<TaskEntity>>> fetchTaskList();

  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query);

  Future<Result<TaskEntity>> setCompletedTask(int taskId);
}

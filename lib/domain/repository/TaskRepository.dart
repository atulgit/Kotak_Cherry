import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/domain/repository/BaseRepository.dart';

import '../../entity/TaskEntity.dart';

abstract interface class TaskRepository extends BaseRepository {
  Future<Result<TaskEntity>> getTask(String taskId);

  Future<Result<TaskEntity>> saveTask(TaskEntity taskEntity);

  Future<Result<List<TaskEntity>>> getTaskList();

  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query);
}

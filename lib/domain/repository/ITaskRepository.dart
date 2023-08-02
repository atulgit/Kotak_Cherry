import 'package:kotak_cherry/common/KCResult.dart';
import 'package:kotak_cherry/domain/repository/BaseRepository.dart';
import 'package:kotak_cherry/entity/AttachmentEntity.dart';

import '../../entity/TaskEntity.dart';

abstract interface class ITaskRepository extends BaseRepository {
  Future<Result<TaskEntity>> getTask(String taskId);

  Future<Result<TaskEntity>> saveTask(TaskEntity taskEntity);

  Future<Result<List<TaskEntity>>> getTaskList();

  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query);

  Future<Result<TaskEntity>> setTaskCompleted(int taskId);

  Future<Result> saveAttachments(List<TaskAttachmentEntity> attachments);
}

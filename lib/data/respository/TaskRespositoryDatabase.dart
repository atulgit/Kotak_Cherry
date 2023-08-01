import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/entity/AttachmentEntity.dart';

import '../../entity/TaskEntity.dart';
import '../models/TaskAttachmentDbModel.dart';

abstract interface class TaskRepositoryDatabase {
  Future<Result<TaskEntity>> fetchTask(String id);

  Future<Result<TaskEntity>> saveTask(TaskEntity taskEntity);

  Future<Result<List<TaskEntity>>> fetchTaskList();

  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query);

  Future<Result<TaskEntity>> setCompletedTask(int taskId);

  Future<Result> saveAttachments(List<TaskAttachmentEntity> attachments);
}

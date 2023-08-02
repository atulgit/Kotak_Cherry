import 'package:get_it/get_it.dart';
import 'package:kotak_cherry/common/KCResult.dart';
import 'package:kotak_cherry/data/DatabaseRepoImp/TaskDBRepoImp.dart';
import 'package:kotak_cherry/data/respository/TaskRespositoryDatabase.dart';
import 'package:kotak_cherry/domain/repository/ITaskRepository.dart';
import 'package:kotak_cherry/entity/AttachmentEntity.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

class TaskRepoImp implements ITaskRepository {
  late TaskRepositoryDatabase taskRepositoryDatabase = GetIt.instance<TaskRepositoryDatabase>();

  @override
  Future<Result<TaskEntity>> getTask(String taskId) {
    return taskRepositoryDatabase.fetchTask(taskId);
  }

  @override
  Future<Result<List<TaskEntity>>> getTaskList() {
    return taskRepositoryDatabase.fetchTaskList();
  }

  @override
  Future<Result<TaskEntity>> saveTask(TaskEntity taskEntity) {
    return taskRepositoryDatabase.saveTask(taskEntity);
  }

  @override
  Future<Result<List<TaskEntity>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query) {
    return taskRepositoryDatabase.fetchSortedAndFilteredTask(priority, label, dueDate, sortBy, query);
  }

  @override
  Future<Result<TaskEntity>> setTaskCompleted(int taskId) {
    return taskRepositoryDatabase.setCompletedTask(taskId);
  }

  @override
  Future<Result> saveAttachments(List<TaskAttachmentEntity> attachments) {
    return taskRepositoryDatabase.saveAttachments(attachments);
  }
}

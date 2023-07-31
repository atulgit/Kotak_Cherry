import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/data/DatabaseRepoImp/TaskDatabaseRepoImp.dart';
import 'package:kotak_cherry/data/respository/TaskRespositoryDatabase.dart';
import 'package:kotak_cherry/domain/repository/TaskRepository.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

class TaskRepoImp implements TaskRepository {
  late TaskRepositoryDatabase taskRepositoryDatabase = TaskDatabaseRepoImp();

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
}

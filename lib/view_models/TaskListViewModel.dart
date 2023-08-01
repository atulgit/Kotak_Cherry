import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/data/RepoImp/TaskRepoImp.dart';
import 'package:kotak_cherry/domain/user_cases/BaseUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchCompletedTasksUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchFilteredAndSortedTasksUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchFilteredCompletedTasksUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchTaskListUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchTaskUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/SaveTaskUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/SetCompletedTaskUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/TaskUseCase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';
import 'package:kotak_cherry/view_models/BaseViewModel.dart';

class TaskListViewModel extends BaseViewModel {
  List<TaskEntity> taskList = [];
  List<TaskEntity> completedTaskList = [];

  int taskId = -1;
  int priority = -1;
  int label = -1;
  int sortBy = -1;
  String dueDate = "";
  String query = "";

  void getTask() async {
    var taskUseCase = FetchTaskUseCase(TaskRepoImp());
    var result = await taskUseCase.invoke(FetchTaskUseCaseParams("100"));

    switch (result) {
      case Success<TaskEntity>():
        // (result as Success<TaskEntity>).value.id;
        break;

      case Failure<TaskEntity>():
      // TODO: Handle this case.
    }

    notifyListeners();
  }

  void resetFilters() {
    priority = -1;
    label = -1;
    sortBy = -1;
    dueDate = "";

    notifyListeners();
  }

  void markCompletedTask(TaskEntity taskEntity) async {
    var setCompletedTaskUseCase = SetCompletedTaskUseCase();
    var result = await setCompletedTaskUseCase.invoke(SetCompletedTaskUseCaseParams(taskEntity.taskId));

    switch (result) {
      case Success<TaskEntity>():
        // taskEntity.isCompleted = 1;
        // taskEntity.notifyListeners();

        fetchTaskList();
        // notifyListeners();
        break;

      case Failure<TaskEntity>():
        break;
    }
  }

  void fetchTaskList() async {
    var taskListUseCase = FetchTaskListUseCase();
    var result = await taskListUseCase.invoke(FetchTaskListUseCaseParams());

    switch (result) {
      case Success<List<TaskEntity>>():
        taskList.clear();
        taskList.addAll(result.value);

        _fetchCompletedTasks(taskList);
        // notifyListeners();
        break;

      case Failure<List<TaskEntity>>():
        break;
    }

    notifyListeners();
  }

  void _fetchCompletedTasks(List<TaskEntity> tasks) async {
    var taskListUseCase = FetchCompletedTasksUseCase();
    var result = await taskListUseCase.invoke(FetchCompletedTasksUseCaseParams(tasks));

    switch (result) {
      case Success<List<TaskEntity>>():
        completedTaskList.clear();
        completedTaskList.addAll(result.value);

        notifyListeners();
        break;

      case Failure<List<TaskEntity>>():
        break;
    }
  }

  void filterAndSortTasks() async {
    var taskListUseCase = FetchFilteredAndSortedTasksUseCase();
    var result = await taskListUseCase.invoke(FetchFilteredAndSortedTasksUseCaseParams(priority, label, sortBy, dueDate, query));

    switch (result) {
      case Success<List<TaskEntity>>():
        taskList.clear();
        taskList.addAll(result.value);

        // notifyListeners();
        break;

      case Failure<List<TaskEntity>>():
        break;
    }

    notifyListeners();
  }

  void fetchFilteredAndSortedCompletedTasks() async {
    var taskListUseCase = FetchFilteredCompletedTasksUseCase();
    var result = await taskListUseCase.invoke(FetchFilteredCompletedTasksUseCaseParams(priority, label, sortBy, dueDate, query));

    switch (result) {
      case Success<List<TaskEntity>>():
        completedTaskList.clear();
        completedTaskList.addAll(result.value);

        notifyListeners();
        break;

      case Failure<List<TaskEntity>>():
        break;
    }
  }
}

class TaskUseCaseParams extends BaseUseCaseParam {}

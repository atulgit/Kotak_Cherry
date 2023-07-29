import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/data/RepoImp/TaskRepoImp.dart';
import 'package:kotak_cherry/domain/user_cases/BaseUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchFilteredAndSortedTasksUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchTaskListUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/FetchTaskUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/SaveTaskUseCase.dart';
import 'package:kotak_cherry/domain/user_cases/TaskUseCase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';
import 'package:kotak_cherry/view_models/BaseViewModel.dart';

class TaskListViewModel extends BaseViewModel {
  List<TaskEntity> taskList = [];

  int taskId = -1;
  int priority = -1;
  int label = -1;
  int sortBy = -1;
  String dueDate = "";

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

  void fetchTaskList() async {
    var taskListUseCase = FetchTaskListUseCase(TaskRepoImp());
    var result = await taskListUseCase.invoke(FetchTaskListUseCaseParams());

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

  void filterAndSortTasks() async {
    var taskListUseCase = FetchFilteredAndSortedTasksUseCase(TaskRepoImp());
    var result = await taskListUseCase.invoke(FetchFilteredAndSortedTasksUseCaseParams(priority, label, sortBy, dueDate));

    switch (result) {
      case Success<List<TaskEntity>>():
        taskList.clear();
        taskList.addAll(result.value);
        notifyListeners();
        break;

      case Failure<List<TaskEntity>>():
        break;
    }

    notifyListeners();
  }
}

class TaskUseCaseParams extends BaseUseCaseParam {}

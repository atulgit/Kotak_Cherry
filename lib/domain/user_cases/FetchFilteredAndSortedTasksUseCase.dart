import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import 'BaseUseCase.dart';

class FetchFilteredAndSortedTasksUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchFilteredAndSortedTasksUseCaseParams> {
  @override
  var taskRepository;

  FetchFilteredAndSortedTasksUseCase(this.taskRepository) : super(taskRepository);

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchFilteredAndSortedTasksUseCaseParams params) async {
    var result = await taskRepository.fetchSortedAndFilteredTask(params.priority, params.label, params.dueDate, params.sortBy);
    switch (result) {
      case Success<List<TaskEntity>>():
        var tasks = result.value;
        if (params.sortBy == 0) tasks.sort((a, b) => a.compareByPriority(b));
        if (params.sortBy == 1) tasks.sort((a, b) => a.compareByDate(b));
        return Success<List<TaskEntity>>(tasks);

      case Failure<List<TaskEntity>>():
        return const Failure();
    }

    // return taskRepository.fetchSortedAndFilteredTask(params.priority, params.label, params.dueDate, params.sortBy);
  }
}

class FetchFilteredAndSortedTasksUseCaseParams {
  int priority = -1;
  String dueDate = "";
  int label = -1;
  int sortBy = -1;

  FetchFilteredAndSortedTasksUseCaseParams(this.priority, this.label, this.sortBy, this.dueDate);
}

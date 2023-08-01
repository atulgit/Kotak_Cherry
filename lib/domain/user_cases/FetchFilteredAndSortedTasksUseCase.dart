import 'package:get_it/get_it.dart';

import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import '../repository/ITaskRepository.dart';
import 'BaseUseCase.dart';

class FetchFilteredAndSortedTasksUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchFilteredAndSortedTasksUseCaseParams> {
  FetchFilteredAndSortedTasksUseCase() : super(GetIt.instance<ITaskRepository>());

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchFilteredAndSortedTasksUseCaseParams params) async {
    var result = await taskRepository.fetchSortedAndFilteredTask(params.priority, params.label, params.dueDate, params.sortBy, params.query);
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
  String query = "";

  FetchFilteredAndSortedTasksUseCaseParams(this.priority, this.label, this.sortBy, this.dueDate, this.query);
}

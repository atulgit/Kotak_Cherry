import 'package:get_it/get_it.dart';

import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import '../repository/ITaskRepository.dart';
import 'BaseUseCase.dart';
import 'FetchFilteredAndSortedTasksUseCase.dart';

class FetchFilteredCompletedTasksUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchFilteredCompletedTasksUseCaseParams> {
  FetchFilteredCompletedTasksUseCase() : super(GetIt.instance<ITaskRepository>());

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchFilteredCompletedTasksUseCaseParams params) async {
    var useCaseParams = FetchFilteredAndSortedTasksUseCaseParams(params.priority, params.label, params.sortBy, params.dueDate, params.query);
    var useCase = FetchFilteredAndSortedTasksUseCase();
    var result = await useCase.invoke(useCaseParams);
    switch (result) {
      case Success<List<TaskEntity>>():
        var tasks = result.value;
        return Success<List<TaskEntity>>(tasks.where((element) => element.isCompleted == 1).toList());

      case Failure<List<TaskEntity>>():
        return const Failure();
    }
  }
}

class FetchFilteredCompletedTasksUseCaseParams {
  int priority = -1;
  String dueDate = "";
  int label = -1;
  int sortBy = -1;
  String query = "";

  FetchFilteredCompletedTasksUseCaseParams(this.priority, this.label, this.sortBy, this.dueDate, this.query);
}

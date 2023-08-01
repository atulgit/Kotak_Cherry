import 'package:get_it/get_it.dart';

import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import '../repository/TaskRepository.dart';
import 'BaseUseCase.dart';

class FetchCompletedTasksUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchCompletedTasksUseCaseParams> {
  FetchCompletedTasksUseCase() : super(GetIt.instance<TaskRepository>());

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchCompletedTasksUseCaseParams params) {
    var completedTasks = params.tasks.where((element) => element.isCompleted == 1).toList();
    return Future(() => Success(completedTasks));
  }
}

class FetchCompletedTasksUseCaseParams {
  List<TaskEntity> tasks = [];

  FetchCompletedTasksUseCaseParams(this.tasks);
}

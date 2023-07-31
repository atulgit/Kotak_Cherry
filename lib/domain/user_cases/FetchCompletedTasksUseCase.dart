import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import 'BaseUseCase.dart';

class FetchCompletedTasksUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchCompletedTasksUseCaseParams> {
  @override
  var taskRepository;

  FetchCompletedTasksUseCase(this.taskRepository) : super(taskRepository);

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

import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import 'BaseUseCase.dart';

class FetchTaskListUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchTaskListUseCaseParams> {
  @override
  var taskRepository;

  FetchTaskListUseCase(this.taskRepository) : super(taskRepository);

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchTaskListUseCaseParams params) {
    return taskRepository.getTaskList();
  }
}

class FetchTaskListUseCaseParams {
  FetchTaskListUseCaseParams();
}

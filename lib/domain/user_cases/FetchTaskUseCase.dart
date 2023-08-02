import 'package:kotak_cherry/common/KCResult.dart';
import 'package:kotak_cherry/domain/user_cases/BaseUseCase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

class FetchTaskUseCase extends BaseUseCase<Future<Result<TaskEntity>>, FetchTaskUseCaseParams> {
  @override
  var taskRepository;

  FetchTaskUseCase(this.taskRepository) : super(taskRepository);

  @override
  Future<Result<TaskEntity>> invoke(FetchTaskUseCaseParams params) {
    return taskRepository.getTask(params.taskId);
  }
}

class FetchTaskUseCaseParams {
  String taskId = "";

  FetchTaskUseCaseParams(this.taskId);
}

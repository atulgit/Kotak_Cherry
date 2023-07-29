import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/domain/user_cases/BaseUseCase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

class SaveTaskUseCase extends BaseUseCase<Future<Result<TaskEntity>>, SaveTaskUseCaseParams> {
  @override
  var taskRepository;

  SaveTaskUseCase(this.taskRepository) : super(taskRepository);

  @override
  Future<Result<TaskEntity>> invoke(SaveTaskUseCaseParams params) {
    return taskRepository.saveTask(params.taskEntity);
  }
}

class SaveTaskUseCaseParams {
  TaskEntity taskEntity;

  SaveTaskUseCaseParams(this.taskEntity);
}

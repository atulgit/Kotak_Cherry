import 'package:get_it/get_it.dart';
import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/domain/user_cases/BaseUseCase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

import '../repository/TaskRepository.dart';

class SaveTaskUseCase extends BaseUseCase<Future<Result<TaskEntity>>, SaveTaskUseCaseParams> {

  SaveTaskUseCase() : super(GetIt.instance<TaskRepository>());

  @override
  Future<Result<TaskEntity>> invoke(SaveTaskUseCaseParams params) {
    return taskRepository.saveTask(params.taskEntity);
  }
}

class SaveTaskUseCaseParams {
  TaskEntity taskEntity;

  SaveTaskUseCaseParams(this.taskEntity);
}

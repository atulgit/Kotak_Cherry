import 'package:get_it/get_it.dart';

import '../../common/KCResult.dart';
import '../../entity/TaskEntity.dart';
import '../repository/ITaskRepository.dart';
import 'BaseUseCase.dart';

class SetCompletedTaskUseCase extends BaseUseCase<Future<Result<TaskEntity>>, SetCompletedTaskUseCaseParams> {
  SetCompletedTaskUseCase() : super(GetIt.instance<ITaskRepository>());

  @override
  Future<Result<TaskEntity>> invoke(SetCompletedTaskUseCaseParams params) {
    return taskRepository.setTaskCompleted(params.taskId);
  }
}

class SetCompletedTaskUseCaseParams {
  int taskId;

  SetCompletedTaskUseCaseParams(this.taskId);
}

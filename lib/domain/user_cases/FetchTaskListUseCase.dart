import 'package:get_it/get_it.dart';
import 'package:kotak_cherry/domain/repository/ITaskRepository.dart';

import '../../common/KotalResult.dart';
import '../../entity/TaskEntity.dart';
import 'BaseUseCase.dart';

class FetchTaskListUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchTaskListUseCaseParams> {
  FetchTaskListUseCase() : super(GetIt.instance<ITaskRepository>());

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchTaskListUseCaseParams params) {
    return taskRepository.getTaskList();
  }
}

class FetchTaskListUseCaseParams {
  FetchTaskListUseCaseParams();
}

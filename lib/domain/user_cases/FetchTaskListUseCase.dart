import 'package:get_it/get_it.dart';
import 'package:kotak_cherry/domain/repository/ITaskRepository.dart';

import '../../common/KCResult.dart';
import '../../entity/TaskEntity.dart';
import 'BaseUseCase.dart';

class FetchTaskListUseCase extends BaseUseCase<Future<Result<List<TaskEntity>>>, FetchTaskListUseCaseParams> {
  FetchTaskListUseCase() : super(GetIt.instance<ITaskRepository>());

  @override
  Future<Result<List<TaskEntity>>> invoke(FetchTaskListUseCaseParams params) async {
    var result = await taskRepository.getTaskList();
    switch (result) {
      case Success<List<TaskEntity>>():
        var tasks = result.value;
        tasks.sort((a, b) => a.compareByTaskId(b));
        return Success<List<TaskEntity>>(tasks);

      case Failure<List<TaskEntity>>():
        return const Failure();
    }
  }
}

class FetchTaskListUseCaseParams {
  FetchTaskListUseCaseParams();
}

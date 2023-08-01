import 'package:get_it/get_it.dart';
import 'package:kotak_cherry/common/KotalResult.dart';
import 'package:kotak_cherry/domain/user_cases/BaseUseCase.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';

import '../../entity/AttachmentEntity.dart';
import '../repository/ITaskRepository.dart';

class SaveTaskUseCase extends BaseUseCase<Future<Result<TaskEntity>>, SaveTaskUseCaseParams> {
  SaveTaskUseCase() : super(GetIt.instance<ITaskRepository>());

  @override
  Future<Result<TaskEntity>> invoke(SaveTaskUseCaseParams params) async {
    var result = await taskRepository.saveTask(params.taskEntity);
    switch (result) {
      case Success<TaskEntity>():
        var attResult = await taskRepository.saveAttachments(params.attachments);
        switch (attResult) {
          case Success():
            return Success(result.value);

          case Failure():
            return const Failure<TaskEntity>();
        }

      case Failure<TaskEntity>():
        return const Failure<TaskEntity>();
    }
  }
}

class SaveTaskUseCaseParams {
  TaskEntity taskEntity;
  List<TaskAttachmentEntity> attachments = [];

  SaveTaskUseCaseParams(this.taskEntity, {this.attachments = const []});
}

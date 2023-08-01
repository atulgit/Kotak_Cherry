import 'package:kotak_cherry/domain/repository/BaseRepository.dart';
import 'package:kotak_cherry/domain/repository/ITaskRepository.dart';

abstract class BaseUseCase<T, R> {
  ITaskRepository taskRepository;

  BaseUseCase(this.taskRepository);

  T invoke(R params);
}

abstract class BaseUseCaseParam {}

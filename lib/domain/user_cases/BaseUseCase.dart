import 'package:kotak_cherry/domain/repository/BaseRepository.dart';
import 'package:kotak_cherry/domain/repository/TaskRepository.dart';

abstract class BaseUseCase<T, R> {
  TaskRepository taskRepository;

  BaseUseCase(this.taskRepository);

  T invoke(R params);
}

abstract class BaseUseCaseParam {}

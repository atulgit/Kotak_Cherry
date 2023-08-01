import 'package:get_it/get_it.dart';

import '../data/RepoImp/TaskRepoImp.dart';
import '../domain/repository/ITaskRepository.dart';

mixin DependencyInitializer {
  static void init() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton<ITaskRepository>(TaskRepoImp(), signalsReady: true);
  }
}

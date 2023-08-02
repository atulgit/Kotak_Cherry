import 'package:get_it/get_it.dart';
import 'package:kotak_cherry/data/DatabaseRepoImp/TaskDBRepoImp.dart';
import 'package:kotak_cherry/data/respository/TaskRespositoryDatabase.dart';

import '../data/RepoImp/TaskRepoImp.dart';
import '../domain/repository/ITaskRepository.dart';

mixin DependencyInitializer {
  static void initDependencies() {
    _initTaskRepo();
    _initTaskDbRepo();
  }

  //Initialize Task Repository with TaskRepoImp implementation with Singleton object.
  static void _initTaskRepo() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton<ITaskRepository>(TaskRepoImp(), signalsReady: true);
  }

  //Initialize Task Database Repository with TaskDatabaseRepoImp implementation with Singleton object.
  static void _initTaskDbRepo() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton<TaskRepositoryDatabase>(TaskDBRepoImp(), signalsReady: true);
  }
}

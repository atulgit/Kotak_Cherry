import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kotak_cherry/common/KCUtility.dart';
import 'package:kotak_cherry/data/data_sources/local/DBConstants.dart';
import 'package:kotak_cherry/data/models/TaskAttachmentDbModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/KotalResult.dart';
import '../../../models/TaskDbModel.dart';

class DatabaseService {
  static init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    _registerDataModels();
  }

  static _registerDataModels() {
    if (!Hive.isAdapterRegistered(TaskDbModelAdapter().typeId)) {
      Hive.registerAdapter(TaskDbModelAdapter());
    }
  }

  static Future<Box<TaskDbModel>> get _database_tasks => Hive.openBox<TaskDbModel>(DBContants.TBL_Task);

  static Future<Box<TaskAttachmentDbModel>> get _database_attachments => Hive.openBox<TaskAttachmentDbModel>(DBContants.TBL_Attachments);

  static final DatabaseService databaseService = DatabaseService._internal();

  factory DatabaseService() => databaseService;

  DatabaseService._internal();

  List<TaskDbModel> tasks = [
    // TaskDbModel("description", task_id: "100", task_priority: 1, due_date: "2023-09-29", title: "title 1", task_label: 1),
    // TaskDbModel("description", task_id: "101", task_priority: 2, due_date: "2023-09-28", title: "title 2", task_label: 2),
    // TaskDbModel("description", task_id: "101", task_priority: 3, due_date: "2023-06-27", title: "title 3", task_label: 2),
    // TaskDbModel("description", task_id: "101", task_priority: 0, due_date: "2023-09-26", title: "title 0", task_label: 2)
  ];

  Future<Result<TaskDbModel>> fetchTask(String id) async {
    try {
      return Success<TaskDbModel>(tasks.where((element) => element.task_id == id).single);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<List<TaskDbModel>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query) async {
    try {
      final database = await _database_tasks;
      tasks = database.values.toList();

      return Success<List<TaskDbModel>>(tasks
          .where((element) =>
              (priority == -1 || element.task_priority == priority) &&
              (label == -1 || element.task_label == label) &&
              (query.isEmpty || element.title.toLowerCase().contains(query.toLowerCase())) &&
              (dueDate.isEmpty || KCUtility.getFormattedDate(dueDate.trim()) == KCUtility.getFormattedDate(element.due_date.trim())))
          .toList());
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<List<TaskDbModel>>> fetchTaskList() async {
    try {
      final database = await _database_tasks;
      tasks = database.values.toList();

      return Success<List<TaskDbModel>>(tasks);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<TaskDbModel>> setCompletedTask(int taskId) async {
    try {
      final database = await _database_tasks;
      var task = database.get(taskId);
      task?.is_completed = 1;
      database.put(taskId, task!);

      return Success<TaskDbModel>(task);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<TaskDbModel>> saveTask(TaskDbModel taskDbModel) async {
    try {
      final database = await _database_tasks;
      await database.add(taskDbModel);

      tasks.add(taskDbModel);
      return Success<TaskDbModel>(taskDbModel);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result> saveAttachments(List<TaskAttachmentDbModel> attachments) async {
    try {
      final database = await _database_attachments;
      attachments.map((e) async {
        await database.add(e);
      });

      return const Success<void>(1);
    } catch (e) {
      return const Failure();
    }
  }
}

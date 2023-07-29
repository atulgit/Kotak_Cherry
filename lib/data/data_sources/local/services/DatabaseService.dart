import 'package:kotak_cherry/common/KCCommon.dart';
import 'package:kotak_cherry/data/data_sources/local/DBConstants.dart';
import 'package:localstore/localstore.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/KotalResult.dart';
import '../../../models/TaskDbModel.dart';

class DatabaseService {
  static final db = Localstore.instance;
  static List<TaskDbModel> tasks = [
    TaskDbModel("description", task_id: "100", task_priority: 1, due_date: "2023-09-29", title: "title 1", task_label: 1),
    TaskDbModel("description", task_id: "101", task_priority: 2, due_date: "2023-09-28", title: "title 2", task_label: 2),
    TaskDbModel("description", task_id: "101", task_priority: 3, due_date: "2023-06-27", title: "title 3", task_label: 2),
    TaskDbModel("description", task_id: "101", task_priority: 0, due_date: "2023-09-26", title: "title 0", task_label: 2)
  ];

  // static List<TaskDbModel> tasks = [
  //
  // ];

  static Future<Result<TaskDbModel>> fetchTask(String id) async {
    try {
      // var uuid = const Uuid();
      // var taskModel = await db.collection(DBContants.TBL_Task).get();
      // return Success<TaskDbModel>(TaskDbModel.fromMap(taskModel as Map<String, dynamic>));

      return Success<TaskDbModel>(tasks.where((element) => element.task_id == id).single);
    } catch (e) {
      return const Failure();
    }
  }

  static Future<Result<List<TaskDbModel>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy) async {
    try {
      // var uuid = const Uuid();
      // var taskModel = await db.collection(DBContants.TBL_Task).get();
      // return Success<TaskDbModel>(TaskDbModel.fromMap(taskModel as Map<String, dynamic>));

      return Success<List<TaskDbModel>>(tasks
          .where((element) =>
              (priority == -1 || element.task_priority == priority) &&
              (label == -1 || element.task_label == label) &&
              (dueDate.isEmpty || KCCommon.getFormattedDate(dueDate.trim()) == KCCommon.getFormattedDate(element.due_date.trim())))
          .toList());
    } catch (e) {
      return const Failure();
    }
  }

  static Future<Result<List<TaskDbModel>>> fetchTaskList() async {
    try {
      // var uuid = const Uuid();
      // var taskModel = await db.collection(DBContants.TBL_Task).get();
      // return Success<TaskDbModel>(TaskDbModel.fromMap(taskModel as Map<String, dynamic>));

      return Success<List<TaskDbModel>>(tasks);
    } catch (e) {
      return const Failure();
    }
  }

  static Future<Result<TaskDbModel>> saveTask(TaskDbModel taskDbModel) async {
    try {
      tasks.add(taskDbModel);
      // var uuid = const Uuid();
      // db.collection(DBContants.TBL_Task).doc("100").set(taskDbModel.toMap());
      // return Success<TaskDbModel>(taskDbModel);
      return Success<TaskDbModel>(taskDbModel);
    } catch (e) {
      return const Failure();
    }
  }
}

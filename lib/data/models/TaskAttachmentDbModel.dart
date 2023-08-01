import 'package:hive/hive.dart';

part 'TaskAttachmentDbModel.g.dart';

@HiveType(typeId: 1)
class TaskAttachmentDbModel extends HiveObject {
  @HiveField(0)
  int attachmentId = -1;
  @HiveField(1)
  int taskId = -1;
  @HiveField(2)
  String name = "";
  @HiveField(3)
  String url = "";
  @HiveField(4)
  String type = "";

  TaskAttachmentDbModel(this.taskId, this.name, this.attachmentId, this.url, this.type);
}

import 'package:kotak_cherry/entity/BaseEntity.dart';

class TaskAttachmentEntity extends BaseEntity {
  int attachmentId = -1;
  int taskId = -1;
  String name = "";
  String url = "";
  String type = "";
}

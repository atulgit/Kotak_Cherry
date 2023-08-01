import 'package:kotak_cherry/view_models/BaseViewModel.dart';

import '../entity/AttachmentEntity.dart';

class TaskAttachmentViewModel extends BaseViewModel {
  List<TaskAttachmentEntity> attachments = [];

  void addAttachment(TaskAttachmentEntity attachmentEntity) {
    attachments.add(attachmentEntity);
    notifyListeners();
  }

  void deleteAttachment(TaskAttachmentEntity attachmentEntity) {
    attachments.remove(attachmentEntity);
    notifyListeners();
  }
}

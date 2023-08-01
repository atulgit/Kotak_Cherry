import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/view_models/TaskAttachmentViewModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../entity/AttachmentEntity.dart';

class TaskAttachmentWidget extends StatefulWidget {
  int taskId = -1;

  TaskAttachmentWidget.fromId(this.taskId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return TaskAttachmentState();
  }
}

class TaskAttachmentState extends State<TaskAttachmentWidget> {
  late final TaskAttachmentViewModel _taskAttachmentViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    _taskAttachmentViewModel = TaskAttachmentViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(children: [
            const Text("Attachments", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            // const SizedBox(width: -10),
            IconButton(
                onPressed: () {
                  _addAttachment();
                },
                icon: const Icon(Icons.add_box, color: Colors.blueGrey, size: 22))
          ])),
      // const SizedBox(height: 10),
      _getAttachmentList()
    ]);
  }

  Widget _getAttachmentList() {
    return ChangeNotifierProvider<TaskAttachmentViewModel>(
        create: (context) => _taskAttachmentViewModel,
        child: Consumer<TaskAttachmentViewModel>(builder: (BuildContext context, TaskAttachmentViewModel value, Widget? child) {
          if (value.attachments.isEmpty) {
            return Padding(padding: const EdgeInsets.only(left: 5), child: _getAttachmentPlaceholder());
          } else {
            return SizedBox(
                width: 600,
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: value.attachments.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider<TaskAttachmentEntity>(
                          create: (context) => value.attachments[index],
                          child: Consumer<TaskAttachmentEntity>(builder: (BuildContext context, TaskAttachmentEntity attValue, Widget? child) {
                            return Padding(
                                padding: const EdgeInsets.all(5),
                                child: InkWell(
                                    onTap: () {
                                      // Overlay.of(context).insert(getAttachmentOptionOverlay());
                                    },
                                    child: GestureDetector(
                                        onTapDown: (details) {
                                          var globalOffset = details.globalPosition;
                                          var localOffset = details.localPosition;
                                          // Overlay.of(context).insert(getAttachmentOptionOverlay(globalOffset));
                                        },
                                        child: Container(
                                            child: Stack(children: [
                                          Positioned(child: _getAttachmentBoxWidget(attValue)),
                                          Positioned(
                                              right: -5,
                                              top: -5,
                                              child: IconButton(
                                                  iconSize: 15,
                                                  icon: const Icon(Icons.delete),
                                                  color: Colors.blueGrey,
                                                  onPressed: () {
                                                    _taskAttachmentViewModel.deleteAttachment(attValue);
                                                    //_taskAttachmentViewModel.deleteAttachment(attValue.attachmentId);
                                                  })),
                                          Positioned(
                                              bottom: 5,
                                              left: 5,
                                              width: 90,
                                              child: Container(
                                                  height: 20,
                                                  color: Colors.blueGrey.shade100.withOpacity(.7),
                                                  child: Center(
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(left: 3, right: 3),
                                                          child: Text(attValue.name,
                                                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))))))
                                        ])))));
                          }));
                    }));
          }
        }));
  }

  Widget _getAttachmentPlaceholder() {
    return SizedBox(
        width: 100,
        height: 100,
        child: InkWell(
            onTap: () {
              _addAttachment();
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey.withOpacity(.5),
                    width: 1,
                  ),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.black,
                  //     // blurRadius: 5.0,
                  //     // offset: Offset(0, 10),
                  //     // spreadRadius: 0.5,
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add))));
  }

  Widget _getAttachmentBoxWidget(TaskAttachmentEntity attachmentEntity) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.white54,
            // blurRadius: 5.0,
            // offset: Offset(0, 10),
            // spreadRadius: 0.5,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        elevation: 1.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(), side: BorderSide(width: .5, color: Colors.blueGrey)),
        child: Image.file(
          _getLocalFile(attachmentEntity.url),
          height: 100.0,
          width: 100.0,
        ),
      ),
    );
  }

  File _getLocalFile(String path) {
    File file = File(path);
    return file;
  }

  Future<void> _addAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var attachmentEntity = TaskAttachmentEntity();
      attachmentEntity.taskId = widget.taskId;
      attachmentEntity.type = result.files.single.extension!;
      attachmentEntity.url = result.files[0].path!; //"http://${result.files.single.extension!}";
      attachmentEntity.name = result.files.single.name!;

      _taskAttachmentViewModel.addAttachment(attachmentEntity);
    } else {}
  }
}

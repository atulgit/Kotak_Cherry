import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:kotak_cherry/common/KCConstants.dart';
import 'package:kotak_cherry/common/KCUtility.dart';
import 'package:kotak_cherry/common/KCExtensions.dart';
import 'package:kotak_cherry/common/enums/TaskLabel.dart';
import 'package:kotak_cherry/ui/common/AppConstants.dart';
import 'package:kotak_cherry/ui/common/CommonStyles.dart';
import 'package:kotak_cherry/ui/common/CommonViews.dart';
import 'package:kotak_cherry/ui/features/attachments/TaskAttachmentWidget.dart';
import 'package:kotak_cherry/view_models/CreateTaskViewModel.dart';
import 'package:provider/provider.dart';

import '../../../common/enums/Priority.dart';
import '../../common/NotificationManager.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateTaskState();
  }
}

class CreateTaskState extends State<CreateTaskScreen> {
  late final CreateTaskViewModel? _createTaskViewModel;
  TaskAttachmentWidget? _taskAttachmentWidget;

  int _selectedPriority = -1;
  int _selectedLabel = -1;
  final double _spacing = 20.0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _notificationTimeConttoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _createTaskViewModel = CreateTaskViewModel();
    _setErrorHandler();
    _taskAttachmentWidget = TaskAttachmentWidget.fromId(-1, onAttachmentAdded: (attachmentEntity) {
      _createTaskViewModel?.addAttachment(attachmentEntity);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _setErrorHandler() {
    _createTaskViewModel?.errorListener.addListener(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sending Message"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: Colors.blueGrey,
            title: const Text(AppConstants.APP_HEADER, style: TextStyle(color: Colors.white))),
        body: Material(child: Padding(padding: const EdgeInsets.all(10), child: _getTaskForm())));
  }

  Widget _getPriorities() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(const DropdownMenuItem(value: "-1", child: Text("Select")));

    PRIORITY.values.forEach((element) {
      menuItems.add(DropdownMenuItem(value: element.value.toString(), child: Text(element.name)));
    });

    return Container(
        width: 120,
        child: DropdownButtonFormField(
            value: _selectedPriority.toString(),
            isExpanded: true,
            items: menuItems,
            validator: (String? value) {
              return (_selectedPriority == -1) ? 'PLease select travel mode.' : null;
            },
            decoration: CommonViews.getDropwDownDecorator("Select Priority", null),
            onChanged: (Object? value) {
              setState(() {
                // _selectedTravelMode = value.toString();
                _selectedPriority = int.parse(value.toString());
              });
            }));
  }

  Widget _getLabels() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(const DropdownMenuItem(value: "-1", child: Text("Select")));

    TASK_LABEL.values.forEach((element) {
      menuItems.add(DropdownMenuItem(value: element.value.toString(), child: Text(element.name)));
    });

    return Container(
        width: 200,
        child: DropdownButtonFormField(
            value: _selectedLabel.toString(),
            isExpanded: true,
            items: menuItems,
            validator: (String? value) {
              return (_selectedLabel == -1) ? 'PLease select label.' : null;
            },
            decoration: CommonViews.getDropwDownDecorator("Select Label", null),
            onChanged: (Object? value) {
              setState(() {
                // _selectedTravelMode = value.toString();
                _selectedLabel = int.parse(value.toString());
              });
            }));
  }

  Widget _getTaskForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Form(
          key: _formKey,
          child: SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const Text("New Task", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _titleController,
                          decoration: CommonViews.getTextEditFieldDecorator("Title", null),
                          onSaved: (String? value) {},
                          validator: (String? value) {
                            return (value == null || value.isEmpty) ? 'Title cant be empty.' : null;
                          },
                        ),
                        SizedBox(height: _spacing),
                        SizedBox(
                            height: 100,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.top,
                              controller: _descriptionController,
                              onSaved: (String? value) {},
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              expands: true,
                              decoration: CommonViews.getTextEditFieldDecorator("Description", null),
                              validator: (String? value) {
                                return (value == null || value.isEmpty) ? 'Title cant be empty.' : null;
                              },
                            )),
                        SizedBox(height: _spacing),
                        Row(children: [_getPriorities(), SizedBox(width: 20), _getLabels()]),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _dueDateController,
                          onTap: () {
                            CommonViews.showDate(context).then((value) {
                              _dueDateController.text = value;
                            });
                          },
                          decoration: CommonViews.getTextEditFieldDecorator("Due Date", null),
                          onSaved: (String? value) {},
                          validator: (String? value) {
                            return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
                          },
                        ),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _notificationTimeConttoller,
                          onTap: () async {
                            var time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 5, minute: 12));
                            _notificationTimeConttoller.text = ("${time!.hour}:${time.minute} ${time.period.name.toUpperCase()}").toString();
                            _createTaskViewModel?.setNotificationTime(time!);
                          },
                          decoration: CommonViews.getTextEditFieldDecorator("Alert Time", null),
                          onSaved: (String? value) {},
                          // validator: (String? value) {
                          //   return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
                          // },
                        ),
                        const SizedBox(height: 10),
                        if (_taskAttachmentWidget != null) _taskAttachmentWidget!,
                        SizedBox(height: _spacing),
                        // const Divider(
                        //   color: Colors.black12,
                        //   height: 1,
                        // ),
                        // SizedBox(height: _spacing),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () async {
                                  _createTask();
                                },
                                style: CommonStyles.buttonStyle,
                                child: const Text("Create Task", style: TextStyle(color: Colors.white))))
                      ])))))
    ]);
  }

  Future<bool> _scheduleNotification(DateTime date) async {
    if (_createTaskViewModel?.notificationTime != null) {
      var time = _createTaskViewModel?.notificationTime;
      date = DateTime(date.year, date.month, date.day, time!.hour, time.minute);
      await NotificationManager.scheduleNotification(_titleController.text.trim(), _descriptionController.text.trim(), date);
      _showCustomDialog(context,
          "${AppConstants.NOTICIFCATION_CREATED_MESSAGE} You will be notified on ${KCUtility.getFormattedDate(date)}, ${time!.hour}:${time!.minute} ${time!.period.name.toUpperCase()}");
      return true;
    }

    return false;
  }

  void _showCustomDialog(BuildContext context, String message) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext cxt) {
        return AlertDialog(
            content: SizedBox(
                height: 190,
                child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text(message, textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"))
                        ])))));
      },
    );
  }

  void _createTask() {
    if (!_formKey.currentState!.validate()) return;

    _createTaskViewModel?.title = _titleController.text;
    _createTaskViewModel?.taskId = 1020;
    _createTaskViewModel?.description = _descriptionController.text.trim();
    _createTaskViewModel?.priority = _selectedPriority;
    _createTaskViewModel?.label = _selectedLabel;
    _createTaskViewModel?.dueDate = _dueDateController.text.trim();
    _createTaskViewModel?.saveTask().then((value) async {
      DateTime date = DateTime.parse(_dueDateController.text.trim());
      var isReminderScheduled = await _scheduleNotification(date);
      if (!isReminderScheduled) Navigator.pop(context);
    });
  }
}

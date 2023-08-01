import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:kotak_cherry/common/Constants.dart';
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
    _taskAttachmentWidget = TaskAttachmentWidget.fromId(-1);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueGrey, title: const Text(AppContants.APP_HEADER, style: TextStyle(color: Colors.white))),
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
                        TextFormField(
                          controller: _descriptionController,
                          onSaved: (String? value) {},
                          decoration: CommonViews.getTextEditFieldDecorator("Description", null),
                          validator: (String? value) {
                            return (value == null || value.isEmpty) ? 'Title cant be empty.' : null;
                          },
                        ),
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
                          validator: (String? value) {
                            return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
                          },
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

  void _createTask() {
    if (!_formKey.currentState!.validate()) return;

    _createTaskViewModel?.title = _titleController.text;
    _createTaskViewModel?.taskId = 1020;
    _createTaskViewModel?.description = "description";
    _createTaskViewModel?.priority = _selectedPriority;
    _createTaskViewModel?.label = _selectedLabel;
    _createTaskViewModel?.dueDate = _dueDateController.text.trim();
    _createTaskViewModel?.saveTask().then((value) async {
      DateTime date = DateTime.parse(_dueDateController.text.trim());

      var time = _createTaskViewModel?.notificationTime;
      date = DateTime(date.year, date.month, date.day, time!.hour, time.minute);

      // DateTime.parse(DateFormat("h:mma").format(date));

      await NotificationManager.scheduleNotification(_titleController.text.trim(), _descriptionController.text.trim(), date);

      Navigator.pop(context);
      // Navigator.pushNamed(context, "/tasklist").then((value) {
      //
      // });
    });
  }
}

extension DateTimeExtension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

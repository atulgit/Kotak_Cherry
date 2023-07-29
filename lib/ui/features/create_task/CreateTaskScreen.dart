import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/common/enums/TaskLabel.dart';
import 'package:kotak_cherry/ui/common/AppConstants.dart';
import 'package:kotak_cherry/ui/common/CommonStyles.dart';
import 'package:kotak_cherry/ui/common/CommonViews.dart';
import 'package:kotak_cherry/view_models/CreateTaskViewModel.dart';

import '../../../common/enums/Priority.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateTaskState();
  }
}

class CreateTaskState extends State<CreateTaskScreen> {
  late final CreateTaskViewModel? _createTaskViewModel;

  int _selectedPriority = -1;
  int _selectedLabel = -1;
  final double _spacing = 40.0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _createTaskViewModel = CreateTaskViewModel();
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
        body: Material(child: Padding(padding: const EdgeInsets.all(10), child: getTaskForm())));
  }

  Widget getPriorities() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(const DropdownMenuItem(value: "-1", child: Text("Select")));

    PRIORITY.values.forEach((element) {
      menuItems.add(DropdownMenuItem(value: element.value.toString(), child: Text(element.name)));
    });

    return Container(
        width: 200,
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

  Widget getLabels() {
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

  Widget getTaskForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Form(
          key: _formKey,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                Row(children: [getPriorities(), SizedBox(width: 20), getLabels()]),
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
                ElevatedButton(
                    onPressed: () {
                      _createTaskViewModel?.title = _titleController.text;
                      _createTaskViewModel?.taskId = 1020;
                      _createTaskViewModel?.description = "description";
                      _createTaskViewModel?.priority = _selectedPriority;
                      _createTaskViewModel?.label = _selectedLabel;
                      _createTaskViewModel?.dueDate = _dueDateController.text.trim();
                      _createTaskViewModel?.saveTask().then((value) {
                        Navigator.pop(context);
                        // Navigator.pushNamed(context, "/tasklist").then((value) {
                        //
                        // });
                      });
                    },
                    style: CommonStyles.buttonStyle,
                    child: const Text("Create Task", style: TextStyle(color: Colors.white)))
              ])))
    ]);
  }
}

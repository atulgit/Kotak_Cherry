import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/common/KCUtility.dart';
import 'package:kotak_cherry/common/enums/Priority.dart';
import 'package:kotak_cherry/common/enums/TaskLabel.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';
import 'package:kotak_cherry/ui/common/LabelSelector.dart';
import 'package:kotak_cherry/ui/common/PrioritySelector.dart';
import 'package:kotak_cherry/ui/common/SortBySelector.dart';
import 'package:kotak_cherry/view_models/TaskListViewModel.dart';
import 'package:provider/provider.dart';

import '../../common/AppConstants.dart';
import '../../common/CommonStyles.dart';
import '../../common/CommonViews.dart';

class TaskListScreen extends StatefulWidget {
  int refresh = -1;

  TaskListScreen({super.key});

  TaskListScreen.fromOptions({Key? key, required this.refresh}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaskListState();
  }
}

class TaskListState extends State<TaskListScreen> {
  final TextEditingController _searchTaskController = TextEditingController();

  late final TaskListViewModel _taskListViewModel;
  late final PrioritySelector _prioritySelector;
  late final LabelSelector _labelSelector;
  late final SortBySelector _filterSelector;
  final TextEditingController _dateSelectorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueGrey, title: const Text(AppContants.APP_HEADER, style: TextStyle(color: Colors.white))),
        body: Material(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ChangeNotifierProvider<TaskListViewModel>(create: (context) => _taskListViewModel!, child: getTaskList()))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _taskListViewModel = TaskListViewModel();
    _prioritySelector = PrioritySelector((p0) {
      _taskListViewModel?.priority = int.parse(p0.toString());
      _taskListViewModel?.filterAndSortTasks();
    });
    _labelSelector = LabelSelector((p0) {
      _taskListViewModel?.label = int.parse(p0.toString());
      _taskListViewModel?.filterAndSortTasks();
    });
    _filterSelector = SortBySelector((p0) {
      _taskListViewModel?.sortBy = int.parse(p0.toString());
      _taskListViewModel?.filterAndSortTasks();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _taskListViewModel?.fetchTaskList();
  }

  Widget getTaskList() {
    return Consumer<TaskListViewModel>(builder: (BuildContext context, TaskListViewModel viewModel, Widget? child) {
      return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Padding(padding: const EdgeInsets.only(top: 10), child: getHeaderOptions()),
            const SizedBox(height: 10),
            if (viewModel.taskList.isEmpty)
              Padding(padding: EdgeInsets.only(top: 50), child: getEmptyListPlaceholder())
            else
              SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: viewModel.taskList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider<TaskEntity>(
                            create: (context) => viewModel.taskList[index],
                            key: UniqueKey(),
                            child: Consumer<TaskEntity>(builder: (BuildContext context, TaskEntity taskEntity, Widget? child) {
                              return Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text(taskEntity.title, style: const TextStyle(fontSize: 16)),
                                          const SizedBox(height: 20),
                                          Stack(children: [
                                            Positioned(
                                                child: Row(children: [
                                              Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.blueGrey),
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                      child: Text(TASK_LABEL.getByValue(taskEntity.taskLabel),
                                                          style: const TextStyle(color: Colors.white, fontSize: 10)))),
                                              const SizedBox(width: 10),
                                              Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.redAccent),
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                      child: Text(PRIORITY.getByValue(taskEntity.taskPriority),
                                                          style: const TextStyle(color: Colors.white, fontSize: 10))))
                                            ])),
                                            Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Row(children: [
                                                  RichText(
                                                      text: TextSpan(children: [
                                                    const TextSpan(
                                                        text: "Due By: ",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black)),
                                                    TextSpan(
                                                        text: KCUtility.getFormattedDate(taskEntity.dueDate),
                                                        style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11, color: Colors.red))
                                                  ]))
                                                ]))
                                          ])
                                        ])),
                                  ));
                            }));
                      })),
          ]));
    });
  }

  Widget getHeaderOptions() {
    Color _getTextColor(Set<MaterialState> states) => states.any(<MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
        }.contains)
            ? Colors.green
            : Colors.blueGrey;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          height: 50,
          child: Row(textDirection: TextDirection.ltr, children: [
            Expanded(
                child: TextFormField(
              controller: _searchTaskController,
              onTap: () {},
              decoration: const InputDecoration(
                hintText: 'Search tasks',
              ),

              onChanged: (value) {
                _taskListViewModel?.query = value;
                if (value.isNotEmpty && value.length > 2) {
                  _taskListViewModel!.filterAndSortTasks();
                }
              },
              expands: true,
              maxLines: null,
              // decoration: CommonViews.getTextEditFieldDecorator("Search Task", null),
              onSaved: (String? value) {},
              validator: (String? value) {
                return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
              },
            )),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () {
                  _taskListViewModel?.query = "";
                  _searchTaskController.text = "";
                  _taskListViewModel!.filterAndSortTasks();
                },
                style: CommonStyles.buttonStyle,
                child: const Text("Clear", style: TextStyle(color: Colors.white)))
          ])),
      const SizedBox(height: 15),
      Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Align(
                          alignment: Alignment.center,
                          child: Material(
                              child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    _prioritySelector!.getPriorities(),
                                    const SizedBox(height: 20),
                                    _labelSelector!.getLabels(),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                        width: 200,
                                        child: TextFormField(
                                          onTap: () {
                                            CommonViews.showDate(context).then((value) {
                                              _dateSelectorController.text = value;
                                              _taskListViewModel?.dueDate = value;
                                              _taskListViewModel?.filterAndSortTasks();
                                            });
                                          },
                                          controller: _dateSelectorController,
                                          decoration: CommonViews.getTextEditFieldDecorator("Select Date", null),
                                          onSaved: (String? value) {},
                                          validator: (String? value) {
                                            return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
                                          },
                                        )),
                                    const SizedBox(height: 20),
                                    _filterSelector.getFilters(),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // _taskListViewModel!.filterAndSortTasks();
                                        },
                                        style: CommonStyles.buttonStyle,
                                        child: const Text("Close", style: TextStyle(color: Colors.white)))
                                  ]))));
                    },
                  );
                },
                child: const Text("Filter & Sort Options", style: TextStyle(fontWeight: FontWeight.bold)))),
        ElevatedButton.icon(
            onPressed: () {
              gotoNewTask();
            },
            icon: const Icon(Icons.add, color: Colors.white),
            style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith(_getTextColor)),
            label: const Text(
              "New Task",
              style: TextStyle(color: Colors.white),
            ))
      ]),
    ]);

    return Stack(children: [
      Positioned(
          left: 0,
          top: 0,
          child: Row(children: [
            _prioritySelector!.getPriorities(),
            _labelSelector!.getLabels(),
            SizedBox(
                width: 200,
                child: TextFormField(
                  onTap: () {
                    CommonViews.showDate(context).then((value) {
                      _dateSelectorController.text = value;
                      _taskListViewModel?.dueDate = value;
                      _taskListViewModel?.filterAndSortTasks();
                    });
                  },
                  controller: _dateSelectorController,
                  decoration: CommonViews.getTextEditFieldDecorator("Select Date", null),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
                  },
                )),
            _filterSelector.getFilters()
          ])),
      Positioned(
          right: 0,
          top: 0,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/createtask").then((value) {
                    _taskListViewModel?.fetchTaskList();
                  });
                },
                style: CommonStyles.buttonStyle,
                child: const Text("Add Task", style: TextStyle(color: Colors.white)))
          ]))
    ]);
  }

  void gotoNewTask() {
    Navigator.pushNamed(context, "/createtask").then((value) {
      _taskListViewModel?.fetchTaskList();
    });
  }

  Widget getEmptyListPlaceholder() {
    return Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Text(AppContants.EMPTY_LIST_PLACEHOLDER),
      const SizedBox(height: 10),
      SizedBox(
          width: 100,
          height: 100,
          child: InkWell(
              onTap: () {
                gotoNewTask();
              },
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey.withOpacity(.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add))))
    ]));
  }
}

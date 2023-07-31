import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/common/KCUtility.dart';
import 'package:kotak_cherry/common/enums/Priority.dart';
import 'package:kotak_cherry/common/enums/TaskLabel.dart';
import 'package:kotak_cherry/entity/TaskEntity.dart';
import 'package:kotak_cherry/ui/common/LabelSelector.dart';
import 'package:kotak_cherry/ui/common/PrioritySelector.dart';
import 'package:kotak_cherry/ui/common/SortBySelector.dart';
import 'package:kotak_cherry/view_models/CreateTaskViewModel.dart';
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

class TaskListState extends State<TaskListScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final TextEditingController _searchTaskController = TextEditingController();

  late final TaskListViewModel _taskListViewModel;
  late final PrioritySelector _prioritySelector;
  late final LabelSelector _labelSelector;
  late final SortBySelector _filterSelector;
  final TextEditingController _dateSelectorController = TextEditingController();

  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blueGrey, title: const Text(AppContants.APP_HEADER, style: TextStyle(color: Colors.white))),
        body: Material(
            child: Padding(padding: const EdgeInsets.all(10), child: ChangeNotifierProvider.value(value: _taskListViewModel!, child: getTaskList())
                // ChangeNotifierProvider<TaskListViewModel>(create: (context) => _taskListViewModel!, child: getTaskList())
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _taskListViewModel = TaskListViewModel();
    _initSelectors();
  }

  void _initSelectors() {
    _prioritySelector = PrioritySelector((p0) {
      _taskListViewModel?.priority = int.parse(p0.toString());
      _taskListViewModel?.filterAndSortTasks();
      _taskListViewModel?.fetchFilteredAndSortedCompletedTasks();
    });

    _labelSelector = LabelSelector((p0) {
      _taskListViewModel?.label = int.parse(p0.toString());
      _taskListViewModel?.filterAndSortTasks();
      _taskListViewModel?.fetchFilteredAndSortedCompletedTasks();
    });
    _filterSelector = SortBySelector((p0) {
      _taskListViewModel?.sortBy = int.parse(p0.toString());
      _taskListViewModel?.filterAndSortTasks();
      _taskListViewModel?.fetchFilteredAndSortedCompletedTasks();
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
      return Column(children: [
        Padding(padding: const EdgeInsets.only(top: 10), child: getHeaderOptions()),
        const SizedBox(height: 10),
        if (viewModel.taskList.isEmpty)
          Padding(padding: const EdgeInsets.only(top: 50), child: getEmptyListPlaceholder())
        else
          getTabBarContent(viewModel)
      ]);
    });
  }

  Widget getTabBarHeader() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(
          icon: Icon(Icons.card_travel, color: Colors.blueGrey),
          child: Text('All Tasks', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
        ),
        Tab(
          icon: Icon(Icons.card_travel_rounded, color: Colors.blueGrey),
          child: Text('Completed Tasks', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget getTabBarContent(TaskListViewModel viewModel) {
    return SizedBox(
        height: 450,
        child: TabBarView(
          controller: _tabController,
          children: [getAllTaskList(viewModel), getCompletedTaskList(viewModel)],
        ));
  }

  Widget getAllTaskList(TaskListViewModel viewModel) {
    return SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: viewModel.taskList.length,
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider.value(
                  value: viewModel.taskList[index],
                  key: UniqueKey(),
                  child: Consumer<TaskEntity>(builder: (BuildContext context, TaskEntity taskEntity, Widget? child) {
                    return getTaskItemUI(taskEntity);
                  }));
            }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget getCompletedTaskList(TaskListViewModel viewModel) {
    return SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: viewModel.completedTaskList.length,
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider.value(
                  value: viewModel.completedTaskList[index],
                  key: UniqueKey(),
                  child: Consumer<TaskEntity>(builder: (BuildContext context, TaskEntity taskEntity, Widget? child) {
                    return getTaskItemUI(taskEntity);
                  }));
            }));
  }

  Widget getTaskItemUI(TaskEntity taskEntity) {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Card(
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(taskEntity.title,
                    style: TextStyle(fontSize: 16, decoration: (taskEntity.isCompleted == 1) ? TextDecoration.lineThrough : TextDecoration.none)),
                // Stack(children: [
                //   Expanded(child: SizedBox(child: Text(taskEntity.title, style: const TextStyle(fontSize: 16)))),
                //   Positioned(
                //       child: ElevatedButton(
                //           onPressed: () {
                //             // _taskListViewModel?.query = "";
                //             // _searchTaskController.text = "";
                //             // _taskListViewModel!.filterAndSortTasks();
                //           },
                //           style: ElevatedButton.styleFrom(elevation: 0.0, backgroundColor: Colors.blueGrey, minimumSize: const Size(60, 20)),
                //           child: const Text("Done", style: TextStyle(color: Colors.white))))
                // ]),
                const SizedBox(height: 20),
                Stack(children: [
                  Positioned(
                      child: Row(children: [
                    Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.green),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(TASK_LABEL.getByValue(taskEntity.taskLabel), style: const TextStyle(color: Colors.white, fontSize: 10)))),
                    const SizedBox(width: 10),
                    Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.redAccent),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            child: Text(PRIORITY.getByValue(taskEntity.taskPriority), style: const TextStyle(color: Colors.white, fontSize: 10))))
                  ])),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Row(children: [
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(text: "Due By: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black)),
                          TextSpan(
                              text: KCUtility.getFormattedDate(taskEntity.dueDate),
                              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11, color: Colors.red))
                        ]))
                      ]))
                ]),
                const SizedBox(height: 20),

                if (taskEntity.isCompleted != 1)
                  Column(children: [
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                    const SizedBox(height: 5),
                    Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () {
                              // _taskListViewModel?.query = "";
                              // _searchTaskController.text = "";
                              // _taskListViewModel!.filterAndSortTasks();

                              taskEntity.isCompleted = 1;
                              _taskListViewModel?.markCompletedTask(taskEntity);
                            },
                            style: ElevatedButton.styleFrom(elevation: 0.0, backgroundColor: Colors.blueGrey, minimumSize: const Size(160, 30)),
                            child: const Text("Mark as Completed", style: TextStyle(color: Colors.white))))
                  ])
              ])),
        ));
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
      getTabBarHeader(),
      const SizedBox(height: 15),
      Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: ElevatedButton.icon(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Align(
                          alignment: Alignment.center,
                          child: Material(
                              child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                                    const Text("Filter and Sort Option",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 16)),
                                    const SizedBox(height: 30),
                                    _prioritySelector.getPriorities(),
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
                                              _taskListViewModel?.fetchFilteredAndSortedCompletedTasks();
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
                                    Row(mainAxisSize: MainAxisSize.min, children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // _taskListViewModel?.resetFilters();
                                            // _taskListViewModel!.filterAndSortTasks();
                                          },
                                          style: CommonStyles.buttonStyle,
                                          child: const Text("Close", style: TextStyle(color: Colors.white))),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                          onPressed: () {
                                            //Navigator.pop(context);
                                            _prioritySelector.setSelectedValue(-1);
                                            _labelSelector.setSelectedValue(-1);
                                            _filterSelector.setSelectedValue(-1);
                                            _dateSelectorController.text = "";
                                            _taskListViewModel?.resetFilters();
                                            _taskListViewModel!.filterAndSortTasks();
                                          },
                                          style: CommonStyles.buttonStyle,
                                          child: const Text("Clear", style: TextStyle(color: Colors.white)))
                                    ])
                                  ]))));
                    },
                  );
                },
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith(_getTextColor)),
                label: const Text(
                  "Filter & Sort Options",
                  style: TextStyle(color: Colors.white),
                ))),
        const SizedBox(width: 20),
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
      const SizedBox(height: 10),
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
                  _taskListViewModel?.fetchFilteredAndSortedCompletedTasks();
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
                  _taskListViewModel?.fetchFilteredAndSortedCompletedTasks();
                },
                style: ElevatedButton.styleFrom(elevation: 0.0, backgroundColor: Colors.blueGrey, minimumSize: const Size(60, 30)),
                child: const Text("Clear", style: TextStyle(color: Colors.white)))
          ])),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

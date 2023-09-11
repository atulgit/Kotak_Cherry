import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/ui/features/play_screen/PlayScreen.dart';

import '../../../data/data_sources/local/services/DatabaseService.dart';
import '../../../data/models/ScoreboardModel.dart';

class PlayMatchScreen extends StatefulWidget {
  const PlayMatchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PlayMatchState();
  }
}

class PlayMatchState extends State<PlayMatchScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  ScoreboardModel? scoreboardModelTeamA;
  ScoreboardModel? scoreboardModelTeamB;

  PlayScreen? _playScreenA;
  PlayScreen? _playScreenB;

  final keyA = GlobalKey<PlayState>();
  final keyB = GlobalKey<PlayState>();

  int lastTabPosition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _playScreenA = PlayScreen("teamA", 0, key: keyA);
    _playScreenB = PlayScreen("teamB", 1, key: keyB);

    _tabController = TabController(length: 2, vsync: this, initialIndex: lastTabPosition);
    _tabController.addListener(() {
      if (_tabController.previousIndex != _tabController.index && _tabController!.index == 0 && keyA.currentState != null) {
        keyA.currentState!.setStateTemp();
      }
      if (_tabController.previousIndex != _tabController.index && _tabController!.index == 1 && keyB.currentState != null) {
        keyB.currentState!.setStateTemp();
      }
    });

    _init();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PlayMatchScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  void _init() async {
    var scrocardA = await DatabaseService.databaseService.getScorecard("teamA");
    var scrocardB = await DatabaseService.databaseService.getScorecard("teamB");

    setState(() {
      scoreboardModelTeamA = scrocardA;
      scoreboardModelTeamB = scrocardB;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (scoreboardModelTeamA == null || _playScreenA == null || _playScreenB == null) {
      return Container();
    } else {
      return Scaffold(
          body: Material(
              child: Column(children: [
        // SizedBox(
        //     height: 100,
        //     child: Padding(
        //         padding: const EdgeInsets.all(10),
        //         child: Expanded(
        //             child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
        //           Text("TOTAL OVERS: ${scoreboardModelTeamA!.totalOvers}"),
        //           const SizedBox(width: 50),
        //           Text("TOTAL PLAYERS: ${scoreboardModelTeamA!.totalPlayers}"),
        //           Expanded(
        //               child: Align(
        //                   alignment: Alignment.centerRight,
        //                   child: ElevatedButton(
        //                       onPressed: () {
        //                         Navigator.pushNamed(context, "/create");
        //                       },
        //                       child: Text("New Match", style: TextStyle(fontSize: 14)))))
        //         ])))),
        Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: const Icon(Icons.sports_cricket, color: Colors.blueGrey),
                  child: Text(scoreboardModelTeamA!.teamName, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  icon: const Icon(Icons.sports_cricket_outlined, color: Colors.blueGrey),
                  child: Text(scoreboardModelTeamB!.teamName, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                ),
              ],
            )),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [_playScreenA!, _playScreenB!],
        ))
      ])));
    }
  }

//
  @override
  bool get wantKeepAlive => false;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/ScoreboardModel.dart';

import '../../../data/models/PlayerModel.dart';

class ScoreboardScreen extends StatefulWidget {
  String teamId = "";
  int selectionMode = 0;

  // int scorecardType = -1; //Batting/Bowling

  ScoreboardScreen(this.teamId, this.selectionMode, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ScoreboardState();
  }
}

class ScoreboardState extends State<ScoreboardScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  List<PlayerModel>? _battingScorecard;
  List<PlayerModel>? _bowlingScorecard;

  ScoreboardModel? _scoreboardModel;

  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _init();
  }

  void _init() async {
    List<PlayerModel>? battingScorecard = await DatabaseService.databaseService.getBattingScoreboard(widget.teamId);
    List<PlayerModel>? bowlingScorecard = await DatabaseService.databaseService.getBowlingScoreboard(widget.teamId);

    var scoreboard = await DatabaseService.databaseService.getScorecard(widget.teamId);

    setState(() {
      _battingScorecard = battingScorecard;
      _bowlingScorecard = bowlingScorecard;

      _scoreboardModel = scoreboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Material(child: _getBody()));
  }

  Widget _getBody() {
    if (_scoreboardModel == null || _battingScorecard == null || _bowlingScorecard == null) {
      return Container();
    }

    return Column(children: [
      TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: const Icon(Icons.sports_cricket, color: Colors.blueGrey),
            child: Text("${_scoreboardModel!.teamName} BATTING", style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ),
          Tab(
            icon: const Icon(Icons.sports_cricket_outlined, color: Colors.blueGrey),
            child: Text("${_scoreboardModel!.teamName} BOWLING", style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      Expanded(
          child: TabBarView(
        controller: _tabController,
        children: [_getTeamScorecard(0, _battingScorecard), _getTeamScorecard(1, _bowlingScorecard)],
      ))
    ]);
  }

  Widget _getTeamScorecard(int scoreboardType, List<PlayerModel>? scorecard) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Text(_scoreboardModel!.teamName, textAlign: TextAlign.start, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          // const SizedBox(height: 10),
          SizedBox(
              height: 280,
              width: double.infinity,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  child: Expanded(
                      child: DataTable(columns: const [
                    DataColumn(label: Text("Player Name")),
                    DataColumn(label: Text("Runs")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("DRS")),
                    DataColumn(label: Text("Level")),
                    DataColumn(label: Text("Overs"))
                  ], rows: [
                    for (var player in scorecard!)
                      DataRow(cells: [
                        DataCell(AbsorbPointer(
                            absorbing: scoreboardType == 0 ? !_isBatsmanSelectionEnabled() : !_isBowlerSelectionEnabled(player),
                            child: InkWell(
                                onTap: () async {
                                  if (scoreboardType == 0) {
                                    //Batsman Selected
                                    await DatabaseService.databaseService.startBatsmanInning(widget.teamId, player.playerId);
                                  } else if (scoreboardType == 1) {
                                    //Bowler Selected
                                    await DatabaseService.databaseService.startBatsmanInning(widget.teamId, player.playerId);
                                  }
                                  Navigator.pop(context, player);
                                },
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text(player.playerName), const SizedBox(height: 5), _getPlayerStrength(player)])))),
                        DataCell(Text(player.totalScore.toString())),
                        DataCell(Text(_getPlayerStatus(player))),
                        DataCell(Text(player.totalDRS.toString())),
                        DataCell(Text(player.playerType == 0 ? player.batsmanLevel : player.bowlerLevel)),
                        DataCell(Text("${player.overPlayed}.${player.ballsPlayed}"))
                      ]),
                    DataRow(cells: [
                      DataCell(Text("Total", style: _textStyle)),
                      DataCell(Text(_scoreboardModel!.totalScore.toString(), style: _textStyle)),
                      DataCell(Text("", style: _textStyle)),
                      DataCell(Text(_scoreboardModel!.BATDRSTaken.toString(), style: _textStyle)),
                      const DataCell(Text("")),
                      DataCell(Text("${_scoreboardModel!.currentOver}.${_scoreboardModel!.currentOverBall}/${_scoreboardModel!.totalOvers}",
                          style: _textStyle))
                    ])
                  ]))))
        ]));
  }

  //Check if any batsman Id is playing currently, in ScorboardModel.
  //This method assumes to be called only in case of batting team.
  bool _isBatsmanSelectionEnabled(PlayerModel playerModel) {
    if (widget.selectionMode == 1 && _scoreboardModel!.currentBatsmanId == -1 && playerModel.batsmanPlayingStatus == 0) return true;

    return false;
  }

  //Check if any bowler Id is playing currently, in ScorboardModel.
  //This method assumes to be called only in case of bowling team.
  bool _isBowlerSelectionEnabled(PlayerModel playerModel) {
    if (widget.selectionMode == 1 &&
        _scoreboardModel!.currentBowlerId == -1 &&
        playerModel.bowlerLevel != "NA" &&
        !_bowlerOversCompleted(playerModel)) return true;

    return false;
  }

  //Check if bowler has played all overs. One bowler can play maximum of totalovers/5.
  //Return true if all overs player, return false if overs left to be played.
  bool _bowlerOversCompleted(PlayerModel playerModel) {
    int bowlerTotalOvers = _scoreboardModel!.totalOvers ~/ 5;
    if (playerModel.overPlayed >= bowlerTotalOvers) return true;

    return false;
  }

  //Initial Strength would be 50 percent
  //two points makes 1 strength
  //One strength made of 1 pixel.
  Widget _getPlayerStrength(PlayerModel playerModel) {
    // playerModel.points = -280;

    double initialStrength = 50;
    double strength = _pointsToStrength(playerModel!.points);

    int maxPoints = 100;
    double minStrength = _pointsToStrength(-maxPoints);
    double maxStrength = _pointsToStrength(maxPoints); //Max strength 50 (to gain), -Min strength 50 (to loose).

    //if (strength == 0) strength = initialStrength; //If strength is zero, initialize with default strength.
    if (strength > maxStrength) strength = maxStrength;
    if (strength < minStrength) strength = minStrength;

    return Container(
      width: initialStrength * 2,
      height: 5.0,
      color: Colors.grey.withOpacity(.3),
      alignment: Alignment.centerLeft,
      child: Container(
        width: initialStrength + strength,
        height: 5.0,
        color: Colors.green,
      ),
    );
  }

  double _pointsToStrength(int points) {
    return points / 2;
  }

  String _getPlayerStatus(PlayerModel playerModel) {
    if (playerModel.batsmanPlayingStatus == 1) {
      return "playing";
    } else if (playerModel.batsmanPlayingStatus == 2) {
      return "out";
    } else {
      return "";
    }
  }
}

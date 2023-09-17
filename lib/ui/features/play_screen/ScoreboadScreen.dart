import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/ScoreboardModel.dart';

import '../../../data/models/PlayerModel.dart';

class ScoreboardScreen extends StatefulWidget {
  String teamId = "";
  int scorecardType = -1;

  ScoreboardScreen(this.teamId, this.scorecardType, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ScoreboardState();
  }
}

class ScoreboardState extends State<ScoreboardScreen> {
  List<PlayerModel>? _scorecard;
  ScoreboardModel? _scoreboardModel;

  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    List<PlayerModel>? scorecard;
    if (widget.scorecardType == 0) {
      //BAT Scoreboard
      scorecard = await DatabaseService.databaseService.getBattingScoreboard(widget.teamId);
    } else if (widget.scorecardType == 1) {
      //BOWL Scoreboard
      scorecard = await DatabaseService.databaseService.getBowlingScoreboard(widget.teamId);
    }

    var scoreboard = await DatabaseService.databaseService.getScorecard(widget.teamId);

    setState(() {
      _scorecard = scorecard;
      _scoreboardModel = scoreboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Material(child: _getBody()));
  }

  Widget _getBody() {
    if (_scoreboardModel == null || _scorecard == null) {
      return Container();
    }

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_scoreboardModel!.teamName, textAlign: TextAlign.start, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: DataTable(columns: const [
                DataColumn(label: Text("Player Name")),
                DataColumn(label: Text("Runs")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("DRS")),
                DataColumn(label: Text("Overs"))
              ], rows: [
                for (var player in _scorecard!)
                  DataRow(cells: [
                    DataCell(InkWell(
                        onTap: () async {
                          if (widget.scorecardType == 0) {
                            //Batsman Selected
                            await DatabaseService.databaseService.startBatsmanInning(widget.teamId, player.playerId);
                          } else if (widget.scorecardType == 1) {
                            //Bowler Selected
                            await DatabaseService.databaseService.startBatsmanInning(widget.teamId, player.playerId);
                          }
                          Navigator.pop(context, player);
                        },
                        child: Text(player.playerName))),
                    DataCell(Text(player.totalScore.toString())),
                    DataCell(Text(_getPlayerStatus(player))),
                    DataCell(Text(player.totalDRS.toString())),
                    DataCell(Text("${player.overPlayed}.${player.ballsPlayed}"))
                  ]),
                DataRow(cells: [
                  DataCell(Text("Total", style: _textStyle)),
                  DataCell(Text(_scoreboardModel!.totalScore.toString(), style: _textStyle)),
                  DataCell(Text("${_scoreboardModel!.currentBatsmanId}/${_scoreboardModel!.totalPlayers}", style: _textStyle)),
                  DataCell(Text(_scoreboardModel!.BATDRSTaken.toString(), style: _textStyle)),
                  DataCell(Text("${_scoreboardModel!.currentOver}.${_scoreboardModel!.currentOverBall}/${_scoreboardModel!.totalOvers}.0",
                      style: _textStyle))
                ])
              ]))
        ]));
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

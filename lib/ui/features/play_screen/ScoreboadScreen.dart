import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/ScoreboardModel.dart';

import '../../../data/models/PlayerModel.dart';

class ScoreboardScreen extends StatefulWidget {
  String teamId = "";

  ScoreboardScreen(this.teamId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ScoreboardState();
  }
}

class ScoreboardState extends State<ScoreboardScreen> {
  List<PlayerModel>? _players;
  ScoreboardModel? _scoreboardModel;

  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() async {
    var players = await DatabaseService.databaseService.getPlayers(widget.teamId);
    var scoreboard = await DatabaseService.databaseService.getScorecard(widget.teamId);

    setState(() {
      _players = players;
      _scoreboardModel = scoreboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Material(child: _getBody()));
  }

  Widget _getBody() {
    if (_scoreboardModel == null || _players == null) {
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
                for (var player in _players!)
                  DataRow(cells: [
                    DataCell(Text(player.playerName)),
                    DataCell(Text(player.totalScore.toString())),
                    DataCell(Text(_getPlayerStatus(player))),
                    DataCell(Text(player.totalDRS.toString())),
                    DataCell(Text("${player.overPlayed}.${player.ballsPlayed}"))
                  ]),
                DataRow(cells: [
                  DataCell(Text("Total", style: _textStyle)),
                  DataCell(Text(_scoreboardModel!.totalScore.toString(), style: _textStyle)),
                  DataCell(Text("${_scoreboardModel!.currentBatsman}/${_scoreboardModel!.totalPlayers}", style: _textStyle)),
                  DataCell(Text(_scoreboardModel!.BATDRSTaken.toString(), style: _textStyle)),
                  DataCell(Text("${_scoreboardModel!.currentOver}.${_scoreboardModel!.currentOverBall}/${_scoreboardModel!.totalOvers}.0",
                      style: _textStyle))
                ])
              ]))
        ]));
  }

  String _getPlayerStatus(PlayerModel playerModel) {
    if (playerModel.playingStatus == 1) {
      return "playing";
    } else if (playerModel.playingStatus == 2) {
      return "out";
    } else {
      return "";
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/ScoreboardModel.dart';

import '../../../data/models/PlayerModel.dart';

class ScoreboardScreen extends StatefulWidget {
  String teamId = "";
  int selectionMode = -1;

  // int selectionType = -1; //0 -> Bating, 1 -> Bowling

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

  ScoreboardModel? _battingInning;
  ScoreboardModel? _bowlingInning;

  final TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.selectionMode == -1 ? 0 : widget.selectionMode; //set Batting/Bowling tab as per selection.
    _init();
  }

  void _init() async {
    List<PlayerModel>? battingScorecard = await DatabaseService.databaseService.getBattingScoreboard(widget.teamId);
    List<PlayerModel>? bowlingScorecard = await DatabaseService.databaseService.getBowlingScoreboard(widget.teamId);

    ScoreboardModel? battingInning;
    ScoreboardModel? bowlingInning;

    if (widget.teamId == "teamA") {
      //If TeamA, get batting scorecard from TeamA and bowling scorecard from TeamB.
      battingInning = await DatabaseService.databaseService.getScorecard(widget.teamId);
      bowlingInning = await DatabaseService.databaseService.getScorecard("teamB");
    } else if (widget.teamId == "teamB") {
      //If TeamB, get batting scorecard from TeamB and bowling scorecard from TeamA.
      battingInning = await DatabaseService.databaseService.getScorecard(widget.teamId);
      bowlingInning = await DatabaseService.databaseService.getScorecard("teamA");
    }

    setState(() {
      _battingScorecard = battingScorecard;
      _bowlingScorecard = bowlingScorecard;

      _battingInning = battingInning;
      _bowlingInning = bowlingInning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Material(child: _getBody()));
  }

  Widget _getBody() {
    if (_battingInning == null || _bowlingInning == null || _battingScorecard == null || _bowlingScorecard == null) {
      return Container();
    }

    return Column(children: [
      TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: const Icon(Icons.sports_cricket, color: Colors.blueGrey),
            child: Text("${_battingInning!.teamName} BATTING", style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ),
          Tab(
            icon: const Icon(Icons.sports_cricket_outlined, color: Colors.blueGrey),
            child: Text("${_battingInning!.teamName} BOWLING", style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
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
                    for (var player in scorecard!) _getRow(scoreboardType, player),
                    _getBottomRow(scoreboardType)
                  ]))))
        ]));
  }

  DataRow _getRow(int scoreboardType, PlayerModel player) {
    return DataRow(
        color: MaterialStateColor.resolveWith((states) {
          return _getPlayerColor(player); //make tha magic!
        }),
        cells: [
          DataCell(AbsorbPointer(
              absorbing:
                  scoreboardType == 0 ? !_isBatsmanSelectionEnabled(scoreboardType, player) : !_isBowlerSelectionEnabled(scoreboardType, player),
              child: InkWell(
                  onTap: () async {
                    if (scoreboardType == 0) {
                      //Batsman Selected
                      await DatabaseService.databaseService.startBatsmanInning(widget.teamId, player.playerId);
                    } else if (scoreboardType == 1) {
                      //Bowler Selected
                      await DatabaseService.databaseService.initOver(player.bowlerLevel == "OB" ? 0 : 1, player.playerId, widget.teamId);
                    }
                    Navigator.pop(context, player);
                  },
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    _getText(player, player.playerName),
                    const SizedBox(height: 5),
                    Opacity(opacity: _getTextOpacity(player), child: _getPlayerStrength(player))
                  ])))),
          DataCell(_getText(player, player.totalScore.toString())), //Total runs scored for batsman, total runs given by bowler.
          DataCell(_getText(player, _getPlayerStatus(player))), //Batsman status (Playing/Out), Bowler Status (Playing/Overs Completed)
          DataCell(_getText(player, player.totalDRS.toString())), //Total DRS taken by batsman or bowler.
          DataCell(_getText(player, player.playerType == 0 ? player.batsmanLevel : player.bowlerLevel)), //Batsman or Bowler Type(Level)
          DataCell(_getText(player, "${player.overPlayed}.${player.ballsPlayed}")) //Batsman or Bowler total overs played.
        ]);
  }

  Widget _getText(PlayerModel player, String text) {
    return Opacity(opacity: _getTextOpacity(player), child: Text(text));
  }

  DataRow _getBottomRow(int scoreboardType) {
    return DataRow(cells: [
      DataCell(Text("Total", style: _textStyle)), //Total Label
      DataCell(Text(_getScores(scoreboardType).toString(), style: _textStyle)), //Total runs scored by team.
      DataCell(Text("", style: _textStyle)),
      DataCell(Text(scoreboardType == 0 ? _battingInning!.BATDRSTaken.toString() : _bowlingInning!.BOWLDRSTaken.toString(), style: _textStyle)),
      const DataCell(Text("")),
      DataCell(Text(_getOvers(scoreboardType), style: _textStyle))
    ]);
  }

  int _getScores(int scoreboardType) {
    if (scoreboardType == 0) {
      return _battingInning!.totalScore;
    } else if (scoreboardType == 1) {
      return _bowlingInning!.totalScore;
    }

    return 0;
  }

  String _getOvers(int scoreboardType) {
    if (scoreboardType == 0) {
      return "${_battingInning!.currentOver}.${_battingInning!.currentOverBall}/${_battingInning!.totalOvers}";
    } else if (scoreboardType == 1) {
      return "${_bowlingInning!.currentOver}.${_bowlingInning!.currentOverBall}/${_bowlingInning!.totalOvers}";
    }

    return "";
  }

  //Check if any batsman Id is playing currently, in ScorboardModel.
  //This method assumes to be called only in case of batting team.
  bool _isBatsmanSelectionEnabled(int type, PlayerModel playerModel) {
    if (widget.selectionMode == 0 && _battingInning!.currentBatsmanId == -1 && playerModel.batsmanPlayingStatus == 0) return true;

    return false;
  }

  //Check if any bowler Id is playing currently, in ScoreboardModel.
  //This method assumes to be called only in case of bowling team.
  bool _isBowlerSelectionEnabled(int type, PlayerModel playerModel) {
    if (widget.selectionMode == 1 && //Bowler selection mode for TeamB will come always from TeamA and wise-versa.
        _bowlingInning!.currentBowlerId == -1 && //In batting inning, there is bowling inning for other team.
        playerModel.bowlerLevel != "NA" &&
        !_bowlerOversCompleted(playerModel)) {
      return true;
    }

    return false;
  }

  //Check if bowler has played all overs. One bowler can play maximum of totalovers/5.
  //Return true if all overs player, return false if overs left to be played.
  bool _bowlerOversCompleted(PlayerModel playerModel) {
    int bowlerTotalOvers = _bowlingInning!.totalOvers ~/ 5;
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

  //Here 2 points are equal to 1 strength.
  double _pointsToStrength(int points) {
    return points / 2;
  }

  String _getPlayerStatus(PlayerModel playerModel) {
    if (playerModel.playerType == 0) {
      if (playerModel.batsmanPlayingStatus == 1) {
        return "Playing";
      } else if (playerModel.batsmanPlayingStatus == 2) {
        return "Out";
      } else {
        return "";
      }
    } else if (playerModel.playerType == 1) {
      if (playerModel.bowlerPlayingStatus == 1) {
        return "Playing";
      } else if (playerModel.bowlerPlayingStatus == 2) {
        return "Out";
      } else {
        return "";
      }
    }

    return "";
  }

  double _getTextOpacity(PlayerModel playerModel) {
    if (playerModel.playerType == 0) {
      //If batsman
      if (playerModel.batsmanPlayingStatus == 1) {
        //Batsman is playing.
        return 1;
      } else if (playerModel.batsmanPlayingStatus == 2) {
        //If batsman is out.
        return 1;
      } else {
        return 1;
      }
    } else if (playerModel.playerType == 1) {
      //if bowler
      if (playerModel.bowlerPlayingStatus == 1) {
        //if bowler is playing the over.
        return 1;
      } else if (playerModel.bowlerPlayingStatus == 2) {
        //if bowler has completed its over.
        return 1;
      } else {
        return 1;
      }
    }

    return 1;
  }

  Color _getPlayerColor(PlayerModel playerModel) {
    if (playerModel.playerType == 0) {
      //If batsman
      if (playerModel.batsmanPlayingStatus == 1) {
        //Batsman is playing.
        return Colors.blueGrey.withOpacity(.1);
      } else if (playerModel.batsmanPlayingStatus == 2) {
        //If batsman is out.
        return Colors.redAccent.withOpacity(.9);
      } else {
        return Colors.white;
      }
    } else if (playerModel.playerType == 1) {
      //if bowler
      if (playerModel.bowlerPlayingStatus == 1) {
        //if bowler is playing the over.
        return Colors.blueGrey.withOpacity(.1);
      } else if (playerModel.bowlerPlayingStatus == 2) {
        //if bowler has completed its over.
        return Colors.grey.withOpacity(.009);
      } else {
        return Colors.white;
      }
    }

    return Colors.white;
  }
}

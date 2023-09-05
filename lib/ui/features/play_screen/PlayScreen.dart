import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kotak_cherry/common/Constants.dart';
import 'package:kotak_cherry/common/KCConstants.dart';
import 'package:kotak_cherry/common/KCResult.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/ScoreboardModel.dart';
import 'package:kotak_cherry/ui/common/Shots.dart';
import 'package:kotak_cherry/ui/shots/OBShots.dart';
import 'package:kotak_cherry/ui/shots/PBShorts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/LifeCycleEventHandler.dart';

class PlayScreen extends StatefulWidget {
  String teamID = "";
  int _index = 0;

  PlayScreen(this.teamID, this._index, {required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayState();
  }
}

class PlayState extends State<PlayScreen> with AutomaticKeepAliveClientMixin {
  ScoreboardModel? scoreboard;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _startInningEnabled = false;

  // String _currentInning = KCConstants.currentInn;

  // ScoreboardModel? scoreboardModelTeamB;
  String _currentView = "bs"; //ss --> Shot Selection, sc --> Score, bs --> bowler selection

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PlayScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  // int _getInitialIndex() {
  //   int initialIndex = PageStorage.of(context).readState(
  //     context,
  //     identifier: widget._index,
  //   ) ??
  //       0;
  //   print("Initial Index ${initialIndex}");
  //   return initialIndex;
  // }

  void init() async {
    var teamScoreboard = await DatabaseService.databaseService.getScorecard(widget.teamID);
    var pref = await _prefs;
    var currentTeam = pref.get("inn");
    setState(() {
      //if (currentTeam != null) _currentInning = currentTeam.toString();
      scoreboard = teamScoreboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (scoreboard == null) return Container();

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(), getScreenOptions(), _getBottomStrip()]))));
  }

  Widget _getStartInningView() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
              child: const Card(
                  child: SizedBox(
                      width: 200,
                      height: 100,
                      child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("START INNING"))))),
              onTap: () async {
                var teamScorecard = await DatabaseService.databaseService.startInning(widget.teamID);
                final SharedPreferences prefs = await _prefs;
                await prefs.setString("inn", widget.teamID);

                setState(() {
                  KCConstants.currentInn = widget.teamID;
                  scoreboard = teamScorecard;
                });
              })
        ]));
  }

  void setStateTemp() {
    setState(() {});
    // enableStartInning();
  }

  //Check for other team, if inning is finished for other team, enable Start Inning for this team.
  void enableStartInning() async {
    bool enable = false;
    if (widget.teamID == "teamA") {
      var scorecardB = await DatabaseService.databaseService.getScorecard("teamB");
      if (scorecardB!.isPlaying == 2) {
        enable = true;
      } else {
        enable = false;
      }
    } else if (widget.teamID == "teamB") {
      var scorecardA = await DatabaseService.databaseService.getScorecard("teamA");
      if (scorecardA!.isPlaying == 2) {
        enable = true;
      } else {
        enable = false;
      }
    }

    setState(() {
      _startInningEnabled = enable;
    });
  }

  // Widget getScreenOptions() {
  //   if (KCConstants.currentInn == "") {
  //     //match is not started yet. No team has started inning.
  //     return _getStartInningView();
  //   } else if (_isInningOver()) {
  //     //If inning is over.
  //     return _getFinalScoreView();
  //   } else {
  //     //Match is started. Team A or Team B is playing.
  //     if (widget.teamID == "teamA" && KCConstants.currentInn == "teamA") {
  //       //if team A is playing currently...
  //       return _getCurrentInningTeamView();
  //     } else if (widget.teamID == "teamB" && KCConstants.currentInn == "teamB") {
  //       //If team B is playing currently...
  //       return _getCurrentInningTeamView();
  //     } else {
  //       //Team A or Team B is waiting... is yet to play.
  //       if (scoreboard!.isPlaying == 0) {
  //         //If inning is not started.
  //         return AbsorbPointer(absorbing: !_startInningEnabled, child: _getStartInningView());
  //       } else {
  //         //Invalid case.
  //         return Container();
  //       }
  //     }
  //   }
  // }

  Widget getScreenOptions() {
    String otherTeamId = "";
    if (widget.teamID == "teamA") {
      otherTeamId = "teamB";
    } else {
      otherTeamId = "teamA";
    }

    return FutureBuilder<ScoreboardModel?>(
        future: DatabaseService.databaseService.getScorecard(otherTeamId),
        builder: (BuildContext context, AsyncSnapshot<ScoreboardModel?> snapshot) {
          if (snapshot.hasData) {
            if (scoreboard!.isPlaying == 0) {
              if (snapshot.data!.isPlaying == 1) {
                return AbsorbPointer(absorbing: true, child: _getStartInningView());
              } else {
                return _getStartInningView();
              }
            } else if (scoreboard!.isPlaying == 1) {
              return _getCurrentInningTeamView();
            } else {
              return _getFinalScoreView();
            }
          } else {
            return Container();
          }
        });

    if (KCConstants.currentInn == "") {
      //match is not started yet. No team has started inning.
      return _getStartInningView();
    } else if (_isInningOver()) {
      //If inning is over.
      return _getFinalScoreView();
    } else {
      //Match is started. Team A or Team B is playing.
      if (widget.teamID == "teamA" && KCConstants.currentInn == "teamA") {
        //if team A is playing currently...
        return _getCurrentInningTeamView();
      } else if (widget.teamID == "teamB" && KCConstants.currentInn == "teamB") {
        //If team B is playing currently...
        return _getCurrentInningTeamView();
      } else {
        //Team A or Team B is waiting... is yet to play.
        if (scoreboard!.isPlaying == 0) {
          //If inning is not started.
          return AbsorbPointer(absorbing: !_startInningEnabled, child: _getStartInningView());
        } else {
          //Invalid case.
          return Container();
        }
      }
    }
  }

  Widget _getCurrentInningTeamView() {
    if (_currentView == "bs") {
      return _getBowlerOptions();
    } else if (_currentView == "ss") {
      return _getShotSelections();
    } else if (_currentView == "sc") {
      return _getScoreView();
    } else {
      return Container();
    }
  }

  bool _isInningOver() {
    if (scoreboard!.isPlaying == 2) return true;
    return false;
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  void _playShot(int shotNumber) async {
    List<Shot> shot = [];
    if (scoreboard!.currentBowlerType == 0) {
      shot = OBShots.SHOTS[shotNumber - 1];
    } else if (scoreboard!.currentBowlerType == 1) {
      shot = PBShots.SHOTS[shotNumber - 1];
    }

    if (shot.isNotEmpty) {
      var shotSlot = random(1, 6);
      var shotObj = shot[shotSlot];

      ScoreboardModel? scoreboardModel = await DatabaseService.databaseService.saveBall(shotObj, widget.teamID);
      setState(() {
        scoreboard = scoreboardModel;
        _currentView = "sc";
      });
    }
  }

  Widget _getShotSelections() {
    return Wrap(children: [
      _getPlayCardItem("Shot 1", () async {
        _playShot(1);
      }),
      _getPlayCardItem("Shot 2", () async {
        _playShot(2);
      }),
      _getPlayCardItem("Shot 3", () async {
        _playShot(3);
      }),
      _getPlayCardItem("Shot 4", () async {
        _playShot(4);
      }),
      _getPlayCardItem("Shot 5", () async {
        _playShot(5);
      }),
      _getPlayCardItem("Shot 6", () async {
        _playShot(6);
      }),
      _getPlayCardItem("Shot 7", () async {
        _playShot(7);
      }),
      _getPlayCardItem("Shot 8", () async {
        _playShot(8);
      }),
      _getPlayCardItem("Shot 9", () async {
        _playShot(9);
      }),
      _getPlayCardItem("Shot 10", () async {
        _playShot(10);
      })
    ]);
  }

  Widget _getPlayCardItem(String item, Function onTap) {
    return InkWell(
        onTap: () {
          if (onTap != null) onTap();
        },
        child: Card(child: SizedBox(width: 100, height: 100, child: Align(alignment: Alignment.center, child: Text(item)))));
  }

  Widget _getBottomStrip() {
    return Row(children: [_getTeamScore(), _getTeamOvers(), _getOverBalls(), _getBowlers()]);
  }

  Widget _getTeamScore() {
    return Text("${scoreboard!.teamName}-${scoreboard!.totalScore}/${scoreboard!.wickets}", style: const TextStyle(fontSize: 18));
  }

  Widget _getTeamOvers() {
    return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text("Overs: ${scoreboard!.currentOver}.${scoreboard!.currentOverBall}", style: const TextStyle(fontSize: 16)));
  }

  Widget _getOverBalls() {
    return Padding(padding: const EdgeInsets.only(left: 30), child: Text(scoreboard!.currentOverString, style: const TextStyle(fontSize: 16)));
  }

  Widget _getFinalScoreView() {
    // if (_isMatchOver()) {
    //   cardLabel = "${scoreboard!.totalScore}/${scoreboard!.wickets}";
    // } else {
    //
    // }

    String cardLabel = "${scoreboard!.totalScore}/${scoreboard!.wickets}";
    return Column(children: [
      Container(
          color: Colors.brown,
          child: SizedBox(
              width: 150,
              height: 150,
              child: Align(alignment: Alignment.center, child: Text(cardLabel, style: const TextStyle(fontSize: 34, color: Colors.white))))),
      // const SizedBox(height: 10),
      // if (!_isInningOver()) //If inning still running, show play button.
      //   ElevatedButton(
      //       onPressed: () {
      //         setState(() {
      //           if(scoreboard!.currentBowlerType == -1) { //If bowler is not selected, show bowler selection view.
      //             _currentView = "bs";
      //           } else { //if bowler is selected, show short selection view.
      //             _currentView = "ss";
      //           }
      //         });
      //       },
      //       child: const Padding(padding: EdgeInsets.all(10), child: Text("Play")))
    ]);
  }

  Widget _getScoreView() {
    String cardLabel = "";
    double? fontSize = 0.0;
    switch (SHOT_TYPE.getByValue(scoreboard!.currentBallShotType)) {
      case SHOT_TYPE.singles:
      case SHOT_TYPE.four:
      case SHOT_TYPE.six:
      case SHOT_TYPE.db:
        fontSize = 34;
        cardLabel = scoreboard!.currentBallScore.toString();
        break;

      case SHOT_TYPE.wicket:
        fontSize = 34;
        cardLabel = "Out!";
        if (scoreboard!.isFreeHit == 1) { //If this is free hit, ignore wicket, display score.
          cardLabel = scoreboard!.currentBallScore.toString();
        }
        break;

      case SHOT_TYPE.none:
        break;

      case SHOT_TYPE.wb:
        fontSize = 24;
        cardLabel = "Wide-Ball! (${scoreboard!.currentBallScore})";
        break;

      case SHOT_TYPE.nb:
        fontSize = 24;
        cardLabel = "No-Ball! (${scoreboard!.currentBallScore})";
        break;

      default:
        break;
    }

    return Column(children: [
      Container(
          color: Colors.brown,
          child: SizedBox(
              width: 150,
              height: 150,
              child: Align(alignment: Alignment.center, child: Text(cardLabel, style: TextStyle(fontSize: fontSize, color: Colors.white))))),
      const SizedBox(height: 10),
      if (!_isInningOver()) //If inning still running, show play button.
        ElevatedButton(
            onPressed: () {
              setState(() {
                //If bowler is not selected, show bowler selection view.
                if (scoreboard!.currentBowlerType == -1) {
                  _currentView = "bs";
                } else {
                  //if bowler is selected, show short selection view.
                  _currentView = "ss";
                }
              });
            },
            child: const Padding(padding: EdgeInsets.all(10), child: Text("Play")))
    ]);
  }

  Widget _getBowlers() {
    String bowler = "";
    if (scoreboard!.currentBowlerType == 0) {
      bowler = "*OB ${scoreboard!.OBOvers} | PB ${scoreboard!.PBOvers}";
    } else if (scoreboard!.currentBowlerType == 1) {
      bowler = "OB ${scoreboard!.OBOvers} | *PB ${scoreboard!.PBOvers}";
    } else {
      bowler = "OB ${scoreboard!.OBOvers} | PB ${scoreboard!.PBOvers}";
    }

    return Padding(padding: const EdgeInsets.only(left: 30), child: Text(bowler, style: TextStyle(fontSize: 16)));
  }

  Widget _getCurrentBatsman() {
    return const Padding(padding: EdgeInsets.only(left: 30), child: Text("B1 10/1.4 | **", style: TextStyle(fontSize: 16)));
  }

  Widget _getBowlerOptions() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
              child: const Card(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("OB"))))),
              onTap: () async {
                _setCurrentBowlerType(0, widget.teamID);
              }),
          InkWell(
              child: const Card(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("PB"))))),
              onTap: () async {
                _setCurrentBowlerType(1, widget.teamID);
              }),
        ]));
  }

  void _setCurrentBowlerType(int bowlerType, String teamId) async {
    var scorecard = await DatabaseService.databaseService.initOver(bowlerType, teamId); //Current bowler for TeamA
    setState(() {
      _currentView = "ss";
      scoreboard = scorecard; //Current bowler for TeamA
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

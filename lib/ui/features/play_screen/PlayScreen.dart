import 'dart:collection';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kotak_cherry/common/Constants.dart';
import 'package:kotak_cherry/common/KCConstants.dart';
import 'package:kotak_cherry/common/KCResult.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';
import 'package:kotak_cherry/data/models/PlayerModel.dart';
import 'package:kotak_cherry/data/models/ScoreboardModel.dart';
import 'package:kotak_cherry/ui/common/Shots.dart';
import 'package:kotak_cherry/ui/shots/DRS_CARDS.dart';
import 'package:kotak_cherry/ui/shots/OBShotCards.dart';
import 'package:kotak_cherry/ui/shots/OBShots.dart';
import 'package:kotak_cherry/ui/shots/PBShorts.dart';
import 'package:kotak_cherry/ui/shots/PBShotCards.dart';
import 'package:kotak_cherry/ui/shots/SHOT_CARDS_PB.dart';
import 'package:kotak_cherry/ui/shots/ShotCard.dart';
import 'package:kotak_cherry/ui/utility/StrengthBuilder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/LifeCycleEventHandler.dart';
import '../../shots/GroupShots.dart';
import '../../shots/SHOT_CARDS_OB.dart';

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
  final player = AudioPlayer();
  ScoreboardModel? scoreboard;
  ScoreboardModel? scoreboardOtherTeam;
  PlayerModel? _currentBatsman;
  PlayerModel? _currentBowler;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  GroupShots? _selectedShotGroup;

  bool _startInningEnabled = false;

  // ScoreboardModel? scoreboardModelTeamB;
  String _currentView =
      "bs"; //ss --> Shot Selection, sc --> Score, bs --> bowler selection, drs --> DRS(Review), ds --> delivery selection for bowler, bts -> batsman selection

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
    super.didUpdateWidget(oldWidget);
  }

  void init() async {
    var teamScoreboard = await DatabaseService.databaseService.getScorecard(widget.teamID);
    await _initCurrentBowlerAndBatsman(teamScoreboard!);
    _setShotGroup();
    var currentView = await _getCurrentView();
    setState(() {
      scoreboard = teamScoreboard;
      _currentView = currentView;
    });
  }

  void _playSound() {
    player.play(
      AssetSource('audios/a1.mp3'),
    );
  }

  void _playBoundarySound(ScoreboardModel scoreboardModel) {
    if (scoreboardModel!.currentBallScore == 6 || scoreboardModel!.currentBallScore == 4) {
      player.play(
        AssetSource('audios/a2.mp3'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (scoreboard == null) return Container();

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Material(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(), getScreenOptions(), _getBottomStrip()]))));
  }

  Widget _getBatsmanOrBowlerSelectionOption(int type) {
    String title = "";
    if (type == 0) {
      title = "SELECT BATSMAN";
    } else {
      title = "SELECT BOWLER";
    }

    String teamId = "";
    if (type == 0) {
      teamId = widget.teamID;
    } else if (type == 1) {
      teamId = _getBowlingTeamId();
      // if (widget.teamID == "teamA") {
      //   teamId = "teamB";
      // } else if (widget.teamID == "teamB") {
      //   teamId = "teamA";
      // }
    }

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
              child: Card(
                  child: SizedBox(
                      width: 200,
                      height: 100,
                      child: Padding(padding: const EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text(title))))),
              onTap: () async {
                Navigator.pushNamed(context, "/scoreboard?teamId=$teamId&selectionMode=$type").then((value) async {
                  //BATSMAN SELECTED By player. Set current batsman
                  if (type == 0) {
                    setState(() {
                      if (scoreboard!.currentBowlerType == -1) {
                        _setCurrentView("bs");
                        //_currentView = "bs";
                      } else {
                        _setCurrentView("ds");
                        // _currentView = "ds";
                      }
                      _currentBatsman = value as PlayerModel;
                    });
                  } else if (type == 1) {
                    //set current bowler.
                    //BOWLER SELECTED
                    _currentBowler = value as PlayerModel;

                    //Get shot groups based on selected batsman level(L1,L2,L3) and selected bowler(OB,PB).
                    //set Default shot group when bowler is selected.
                    _setShotGroup();

                    //After selecting the bowler, initialize over in match scorecard, and change view to delivery selection.
                    if (_currentBowler!.bowlerLevel == "OB") {
                      await _setCurrentBowler(0, _currentBowler!.playerId, widget.teamID);
                    } else if (_currentBowler!.bowlerLevel == "PB") {
                      await _setCurrentBowler(1, _currentBowler!.playerId, widget.teamID);
                    }
                  }
                });
              })
        ]));
  }

  void _setShotGroup() {
    if (_currentBatsman != null && _currentBowler != null) {
      if (_currentBowler!.bowlerLevel == "OB") {
        _selectedShotGroup = SHOT_CARDS_OB.SHOT_CARD_GROUPS[_currentBatsman!.batsmanLevel]![0];
      } else if (_currentBowler!.bowlerLevel == "PB") {
        _selectedShotGroup = SHOT_CARDS_PB.SHOT_CARD_GROUPS[_currentBatsman!.batsmanLevel]![0];
      }
    }
  }

  Future<void> _initCurrentBowlerAndBatsman(ScoreboardModel scoreboardModel) async {
    if (scoreboardModel!.currentBowlerId != -1) {
      _currentBowler = await DatabaseService.databaseService.getBowler(widget.teamID, scoreboardModel!.currentBowlerId);
    }

    if (scoreboardModel!.currentBatsmanId != -1) {
      _currentBatsman = await DatabaseService.databaseService.getBatsman(widget.teamID, scoreboardModel!.currentBatsmanId);
    }
  }

  //Check which team is batting, return the bowling teamId.
  String _getBowlingTeamId() {
    if (scoreboard!.isBatting == 1 && widget.teamID == "teamA") {
      return "teamB";
    } else if (scoreboard!.isBatting == 1 && widget.teamID == "teamB") {
      return "teamA";
    }
    return "";
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
                // final SharedPreferences prefs = await _prefs;
                // await prefs.setString("inn", widget.teamID);

                setState(() {
                  _setCurrentView("bts");
                  // _currentView = "bts"; //Shot batsman selection option, once the inning is started.
                  KCConstants.currentInn = widget.teamID; //Set current playing team Id.
                  scoreboard = teamScorecard; //Update match scorecard after the inning is started.
                });
              })
        ]));
  }

  void _setCurrentView(String view) async {
    _currentView = view;

    if (view != "ss") {
      final SharedPreferences prefs = await _prefs;
      await prefs.setString("view", view);
    }
  }

  Future<String> _getCurrentView() async {
    final SharedPreferences prefs = await _prefs;
    prefs.getString("view");
    if (prefs.containsKey("view")) {
      return prefs.getString("view")!;
    }

    return "";
  }

  void setStateTemp() async {
    await DatabaseService.databaseService.setOtherTeamScoreboard(scoreboard!);
    setState(() {});
    // enableStartInning();
  }

  //Check for other team, if inning is finished for other team, enable Start Inning for this team.
  void enableStartInning() async {
    bool enable = false;
    if (widget.teamID == "teamA") {
      var scorecardB = await DatabaseService.databaseService.getScorecard("teamB");
      if (scorecardB!.isBatting == 2) {
        enable = true;
      } else {
        enable = false;
      }
    } else if (widget.teamID == "teamB") {
      var scorecardA = await DatabaseService.databaseService.getScorecard("teamA");
      if (scorecardA!.isBatting == 2) {
        enable = true;
      } else {
        enable = false;
      }
    }

    setState(() {
      _startInningEnabled = enable;
    });
  }

  Widget getScreenOptions() {
    //Get other teamId. Other than teamId which is assigned to this Widget.
    String otherTeamId = "";
    if (widget.teamID == "teamA") {
      otherTeamId = "teamB";
    } else {
      otherTeamId = "teamA";
    }

    //Get other team Scorecard.
    return FutureBuilder<ScoreboardModel?>(
        future: DatabaseService.databaseService.getScorecard(otherTeamId),
        builder: (BuildContext context, AsyncSnapshot<ScoreboardModel?> snapshot) {
          if (snapshot.hasData) {
            if (scoreboard!.isBatting == 0) {
              //If this teamId inning is not started yet but other teamId is playing, then disable 'Start Inning'.
              if (snapshot.data!.isBatting == 1) {
                //If other team is playing it's inning.
                return AbsorbPointer(absorbing: true, child: _getStartInningView()); //Disable this team's 'Start Inning' option.
              } else {
                return _getStartInningView(); //show start inning for this team.
              }
            } else if (scoreboard!.isBatting == 1) {
              //If this this team is playing, get inning options.
              return _getCurrentInningTeamView();
            } else {
              //case -> isPlaying == 2, if team's inning is completed, get final score view.
              return _getFinalScoreView();
            }
          } else {
            //invalid case.
            return Container();
          }
        });
  }

  //Get options
  Widget _getCurrentInningTeamView() {
    if (_currentView == "bts") {
      return _getBatsmanOrBowlerSelectionOption(0);
    } else if (_currentView == "bs") {
      //Get bowler selection view.
      //return _getBowlerOptions();
      return _getBatsmanOrBowlerSelectionOption(1);
    } else if (_currentView == "ss") {
      //Get batsman shot selection view.
      return _getShotSelections();
    } else if (_currentView == "sc") {
      //Get scorecard view to display scores.
      return _getScoreView();
    } else if (_currentView == "drs") {
      //Get DRS view, (YES/NO) for both Batsman and Bowler.
      return _getDRSView();
    } else if (_currentView == "ds") {
      //Get Delivery Selection from Bowler. (Shot Groups)
      return _getDeliveryOptions();
    } else {
      //Invalid Case.
      return Container();
    }
  }

  bool _isInningOver() {
    if (scoreboard!.isBatting == 2) return true;
    return false;
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  // void _playShot(int shotNumber) async {
  //   //Get Shot-Card, for selected bowler and selected shot number.
  //   List<Shot> shot = [];
  //   if (scoreboard!.currentBowlerType == 0) {
  //     //for OB Bowler.
  //     shot = OBShots.SHOTS[shotNumber - 1];
  //   } else if (scoreboard!.currentBowlerType == 1) {
  //     //For PB Bowler.
  //     shot = PBShots.SHOTS[shotNumber - 1];
  //   }
  //
  //   //If shot-card found, get random shot from shot-card and play shot.
  //   if (shot.isNotEmpty) {
  //     var shotSlot = random(1, 6);
  //     var shotObj = shot[shotSlot];
  //
  //     if (shotObj.shot_type == SHOT_TYPE.tuWicket && !_checkIfDRSAvailable(shotObj)) {
  //       //Check if DRS available for Bat/Bowler, if not available, play with original decision without asking to Batsman/Bowler.
  //       _playDRSShot(false); //Convert DRS shot to 'DB' or 'Wicket' and Play
  //     } else {
  //       // Play if it is not TU-UMPIRE shot.
  //       await _playBall(shotObj);
  //     }
  //   }
  // }

  void _playShot(int shotNumber) async {
    _playSound();

    var shotObj = _getShotObject(shotNumber);

    if (shotObj.shot_type == SHOT_TYPE.tuWicket && !_checkIfDRSAvailable(shotObj)) {
      //Check if DRS available for Bat/Bowler, if not available, play with original decision without asking to Batsman/Bowler.
      _playDRSShot(false); //Convert DRS shot to 'DB' or 'Wicket' and Play
    } else {
      // Play if it is not TU-UMPIRE shot.
      await _playBall(shotObj);
    }
  }

  //Shot No: 13 --> 12, 6
  Shot _getShotObject(int number) {
    //Get Shot Card selected by batsman.
    ShotCard shotCardObj = ShotCard("", "", []);
    shotCardObj = _selectedShotGroup!.shotGroup[number - 1];

    StrengthBuilder strengthBuilder = StrengthBuilder();

    List<Map<String, Shot>> SHOT_CARD_STRENGTH = strengthBuilder.buildStrength(shotCardObj, _currentBatsman!.points, _currentBowler!.points);

    var shotNumber = random(1, 180); //Generate probability number.

    int shotCount = 0; //Probability count for all shots
    //Count probability for all shots one by one until rnd probability no > probability addition for shots.
    for (int i = 0; i < SHOT_CARD_STRENGTH.length; i++) {
      //Get shot card map for all levels (L1, L2, L3)
      Map<String, Shot> shotMap = shotCardObj.SHOT_CARD[i];
      //Get Shot card.
      Shot shotObj = shotMap["SHOT"]!;
      // //Get count for this shot and add
      // shotCount += shotObj.count;

      //Check if third umpire subshot exists.
      if (shotObj.shot_type == SHOT_TYPE.wicket && shotObj.subShot != null) {
        //if Third Umpire exists as Subshot.
        int tuWicketCount = shotObj.subShot!.count; //Third umpire wicket probability count.
        int wicketCount = shotObj.count - tuWicketCount; //Wicket probability count.

        shotCount += tuWicketCount;
        if (shotCount <= shotNumber) {
          return Shot.withCount(shotObj.subShot!.value, shotObj.subShot!.count, SHOT_TYPE.tuWicket);
        } else {
          return shotObj;
        }
      } else {
        //If subshot as tuwicket does not exist.
        //Get count for this shot and add
        shotCount += shotObj.count;

        //Check if probability addition is greater than or equal to random probability no.
        //Select the shot object if probable shot is found.
        if (shotCount >= shotNumber) {
          return shotObj;
        }
      }

      //Check if probability addition is greater than or equal to random probability no.
      //Select the shot object if probable shot is found.
      if (shotCount >= shotNumber) {
        return shotObj;
      }
    }

    return Shot("0", SHOT_TYPE.none);
  }

  //Shot No: 13 --> 12, 6
  Shot _getDRSShotObject() {
    //Get Shot Card selected by batsman.
    List<Map<String, Shot>> drsCardObj = _getDRSCardObject();

    // if (scoreboard!.currentBowlerType == 0) {
    //   //for OB Bowler
    //   if (scoreboard!.DRSTeam == 0) {
    //     //BAT Team Taken DRS
    //     drsCardObj = DRS_CARDS.DRS_CARD_MAX_OUT; //Get max out probability card.
    //   } else if (scoreboard!.DRSTeam == 1) {
    //     //BOWL Team Taken DRS
    //     drsCardObj = DRS_CARDS.DRS_CARD_MAX_OUT; //Get max out probability card.
    //   }
    // } else if (scoreboard!.currentBowlerType == 1) {
    //   //For PB Bowler
    //   if (scoreboard!.DRSTeam == 0) {
    //     //BAT Team Taken DRS
    //     drsCardObj = DRS_CARDS.DRS_CARD_MAX_NOT_OUT; //Get max not-out probability card.
    //   } else if (scoreboard!.DRSTeam == 1) {
    //     //BOWL Team Taken DRS
    //     drsCardObj = DRS_CARDS.DRS_CARD_MAX_NOT_OUT; //Get max not-out probability card.
    //   }
    // }

    var shotNumber = random(1, 6); //Generate probability number.

    int shotCount = 0; //Probability count for all shots
    //Count probability for all shots one by one until rnd probability no > probability addition for shots.
    for (int i = 0; i < drsCardObj.length; i++) {
      //Get shot card map for all levels (L1, L2, L3)
      Map<String, Shot> shotMap = drsCardObj[i];
      //Get Shot card for current batsman level.
      Shot shotObj = shotMap[_currentBatsman!.batsmanLevel]!;
      //Get count for this shot and add
      shotCount += shotObj.count;

      //Check if probability addition is greater than or equal to random probability no.
      //Select the shot object if probable shot is found.
      if (shotCount >= shotNumber) {
        return shotObj;
      }
    }

    return Shot("0", SHOT_TYPE.none);
  }

  //DRS Card probability is Max Out if it is OB Bowler (for both Batsman and Bowler DRS).
  //DRS Card probability is Max Not-Out if it is PB Bowler (for both Batsman and Bowler DRS).
  List<Map<String, Shot>> _getDRSCardObject() {
    List<Map<String, Shot>> drsCardObj = [];
    if (scoreboard!.currentBowlerType == 0) {
      //for OB Bowler
      if (scoreboard!.DRSTeam == 0) {
        //BAT Team Taken DRS
        drsCardObj = DRS_CARDS.DRS_CARD_MAX_OUT; //Get max out probability card.
      } else if (scoreboard!.DRSTeam == 1) {
        //BOWL Team Taken DRS
        drsCardObj = DRS_CARDS.DRS_CARD_MAX_OUT; //Get max out probability card.
      }
    } else if (scoreboard!.currentBowlerType == 1) {
      //For PB Bowler
      if (scoreboard!.DRSTeam == 0) {
        //BAT Team Taken DRS
        drsCardObj = DRS_CARDS.DRS_CARD_MAX_NOT_OUT; //Get max not-out probability card.
      } else if (scoreboard!.DRSTeam == 1) {
        //BOWL Team Taken DRS
        drsCardObj = DRS_CARDS.DRS_CARD_MAX_NOT_OUT; //Get max not-out probability card.
      }
    }

    return drsCardObj;
  }

  //Play randomly generated shot. Also DRS eligible shot.(to mark into the database and then show YES/NO options.)
  Future<void> _playBall(Shot shotObj) async {
    ScoreboardModel? scoreboardModel = await DatabaseService.databaseService.saveBall(shotObj, widget.teamID);
    PlayerModel? batsmanModel = await DatabaseService.databaseService.getBatsman(widget.teamID, _currentBatsman!.playerId);
    PlayerModel? bowlerModel = await DatabaseService.databaseService.getBowler(widget.teamID, _currentBowler!.playerId);
    setState(() {
      //Updated scoreboard after shot is played. Even if it is DRS eligible, update the shot to database, set DRS params. Then show result based on
      //DRS decision taken by Batsman or Bowler.
      scoreboard = scoreboardModel;
      _currentBatsman = batsmanModel;
      _currentBowler = bowlerModel;

      // If this shot is Third-Umpire shot, then show DRS options (YES/NO).
      if (shotObj.shot_type == SHOT_TYPE.tuWicket) {
        _setCurrentView("drs");
        // _currentView = "drs";
      } else {
        //Otherwise show scorecard with play button.
        _setCurrentView("sc");
        // _currentView = "sc";
        _playBoundarySound(scoreboardModel!);
      }

      //Otherwise show scorecard with play button.
      // _currentView = "sc";
      _playBoundarySound(scoreboardModel!);
    });

    // if (_currentView == "sc") {
    //   if (scoreboardModel!.currentBallScore == 6 || scoreboardModel!.currentBallScore == 4) _playBoundarySound();
    // }

    if (await _isMatchCompleted()) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, "/winnerscreen");
    }
  }

  bool _checkIfDRSAvailable(Shot shot) {
    //if BAT Team DRS is remaining
    if (shot.value == "O" && scoreboard!.BATDRSTaken < scoreboard!.totalBATDRS) {
      return true;
    } else if (shot.value == "NO" && scoreboard!.BOWLDRSTaken < scoreboard!.totalBOWLDRS) {
      //if BOWL Team DRS remaining
      return true;
    }

    return false;
  }

  void _playDRSShot(bool isDRS) async {
    //if DRS Taken, get the Third-Umpire shot card.
    if (isDRS) {
      // List<Shot> shot = [];
      // if (scoreboard!.currentBowlerType == 0) {
      //   //Shot card from OB Bowler
      //   shot = OBShots.THIRD_UMPIRE;
      // } else if (scoreboard!.currentBowlerType == 1) {
      //   //Shot card from PB Bowler.
      //   shot = PBShots.THIRD_UMPIRE;
      // }

      //Get Final Decision (Shot Object) from Third Umpire.
      // var shotSlot = random(1, 6);
      var shotObj = _getDRSShotObject(); //shot[shotSlot];
      await _playBall(shotObj);

      //Increment DRS taken for Bat or Bowl team.
      await DatabaseService.databaseService.setDRS(widget.teamID, scoreboard!.currentBatsmanId);
    } else {
      //DRS Not Taken, then play shot with original decision. original decision based on Batsman/Bowler who has discarded the DRS option.
      if (scoreboard!.DRSTeam == 0) {
        //If Batsman has not taken the DRS, mark as OUT.
        Shot shotObj = Shot("O", SHOT_TYPE.wicket); //Create Shot Object for Out, if not taken DRS.
        await _playBall(shotObj);
      } else if (scoreboard!.DRSTeam == 1) {
        //if Bowler has not taken the DRS, mark as dot ball.
        Shot shotObj = Shot("0", SHOT_TYPE.db); //Create Shot Object for Out, if not taken DRS.
        await _playBall(shotObj);
      }
    }

    //clear DRS Status, (DRS team who have been assigned DRS option, Last shot played, marked as DRS)
    await DatabaseService.databaseService.clearDRS(widget.teamID);
  }

  //DRS, YES/NO options.
  Widget _getDRSView() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
              color: Colors.brown,
              child: const SizedBox(
                  width: 100,
                  height: 100,
                  child: Align(alignment: Alignment.center, child: Text("TU-UMP! \n (OUT)", style: TextStyle(fontSize: 20, color: Colors.white))))),
          Text(_getDRSLabel()),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                child: const Card(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("YES"))))),
                onTap: () async {
                  _playDRSShot(true);
                }),
            InkWell(
                child: const Card(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Padding(padding: EdgeInsets.all(5), child: Align(alignment: Alignment.center, child: Text("NO"))))),
                onTap: () async {
                  _playDRSShot(false);
                }),
          ]),
          _getDRSCard()
        ]));
  }

  String _getDRSLabel() {
    if (scoreboard!.DRSTeam == 0) {
      return "BATSMAN DRS";
    } else if (scoreboard!.DRSTeam == 1) {
      return "BOWLER DRS";
    } else {
      return "";
    }
  }

  Widget _getShotCardItem(ShotCard shotCard, int index) {
    StrengthBuilder strengthBuilder = StrengthBuilder();
    // shotCard.SHOT_CARD = strengthBuilder.buildStrength(shotCard);

    var SHOT_CARDS = strengthBuilder.buildStrength(shotCard, _currentBatsman!.points, _currentBowler!.points);

    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: SizedBox(
            width: 3.8 * 180,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              //Card Title and Card Name
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(width: 200, child: Text(shotCard.cardTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (_currentView == "ss")
                  InkWell(
                      onTap: () {
                        _playShot(index);
                      },
                      child: const Card(
                          child: Padding(
                              padding: EdgeInsets.only(left: 40, right: 40),
                              child: Text("Play Shot", style: TextStyle(fontWeight: FontWeight.bold))))),
                SizedBox(width: 200, child: Text(shotCard.cardName, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold)))
              ]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [for (var shotGrp in SHOT_CARDS) _getShotCardItems(shotGrp)])
            ])));
  }

  Widget _getDRSCard() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: SizedBox(
            width: 20 * 6,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [for (var shotGrp in _getDRSCardObject()) _getShotDRSCardItems(shotGrp)])
            ])));
  }

  Widget _getShotDRSCardItems(Map<String, Shot> shotGrp) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [for (int i = 0; i < shotGrp["SHOT"]!.count; i++) _getShotItem(shotGrp["SHOT"]!, i)]);
  }

  Widget _getShotCardItems(Map<String, Shot> shotGrp) {
    Shot shotObj = shotGrp["SHOT"]!;
    print("Shot Data: Type: ${shotObj.shot_type.toString()} Count: ${shotObj.count}");

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [for (int i = 0; i < shotObj.count; i++) _getShotItem(shotGrp["SHOT"]!, i)]);
  }

  Widget _getDeliveryOptions() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //Display all shot groups for selected bowler type and batsman level.
          for (var group in _getShotGroups())
            InkWell(
                onTap: () {
                  setState(() {
                    _selectedShotGroup = group;
                  });
                },
                child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10), child: Text(group.groupName, style: const TextStyle(fontWeight: FontWeight.bold)))))
        ]),
        Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: () {
                  setState(() {
                    // _currentView = "ss";
                    _setCurrentView("ss");
                  });
                },
                child: const Card(
                    color: Colors.amberAccent,
                    child: Padding(padding: EdgeInsets.all(10), child: Text("Bowl It!", style: TextStyle(fontWeight: FontWeight.bold))))))
      ]),
      const SizedBox(height: 10),
      SizedBox(
          height: 160,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              child: Expanded(
                  child: Column(children: [
                if (_selectedShotGroup != null) //When shot group is selected, then display all shots for selected group.
                  for (var shot in _selectedShotGroup!.shotGroup) _getShotCardItem(shot, 0)
              ]))))
    ]);
  }

  Widget _getShotItem(Shot shot, int count) {
    var text = _getShotText(shot);
    if (count > 0) {
      text = "";
    }

    return Container(
        color: _getShotItemBGColor(shot),
        child: const SizedBox(
            width: 3.8,
            height: 20,
            child: Align(
                alignment: Alignment.center,
                child: Text("", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))));
  }

  List<GroupShots> _getShotGroups() {
    if (_currentBowler != null && _currentBatsman != null) {
      if (_currentBowler!.bowlerLevel == "OB") {
        return SHOT_CARDS_OB.SHOT_CARD_GROUPS[_currentBatsman!.batsmanLevel]!;
      } else if (_currentBowler!.bowlerLevel == "PB") {
        return SHOT_CARDS_PB.SHOT_CARD_GROUPS[_currentBatsman!.batsmanLevel]!;
      }
    }

    return [];
  }

  String _getShotText(Shot shot) {
    switch (shot.shot_type) {
      case SHOT_TYPE.six:
      case SHOT_TYPE.four:
      case SHOT_TYPE.singles:
      case SHOT_TYPE.db:
        return shot.value;

      case SHOT_TYPE.wb:
        return "WB";

      case SHOT_TYPE.nb:
        return "NB";

      case SHOT_TYPE.tuWicket:
        return "TU";

      case SHOT_TYPE.wicket:
        if (shot.value == "R") {
          return "RO";
        } else {
          return "O";
        }

      default:
        return "NA";
    }
  }

  Color _getShotItemBGColor(Shot shot) {
    switch (shot.shot_type) {
      case SHOT_TYPE.wicket:
        return Colors.red;

      case SHOT_TYPE.four:
        return Colors.pinkAccent;

      case SHOT_TYPE.singles:
        if (shot.value == "1") {
          return Colors.green;
        } else if (shot.value == "2") {
          return Colors.lightGreen;
        } else {
          return Colors.blueGrey;
        }

      case SHOT_TYPE.six:
        return Colors.purple;

      case SHOT_TYPE.db:
        return Colors.grey;

      case SHOT_TYPE.tuWicket:
        return Colors.amberAccent;

      case SHOT_TYPE.wb:
        return Colors.blue;

      case SHOT_TYPE.nb:
        return Colors.brown;

      default:
        return Colors.black;
    }
  }

  String _getShotCardName(int index) {
    switch (index) {
      case 1:
        return "Safe Singles";

      case 2:
        return "Some More Singles";

      case 3:
        return "Desperate Singles";

      case 4:
        return "Relaxed Score";

      case 5:
        return "Try Four";

      case 6:
        return "Four Boundary";

      case 7:
        return "Try Six";

      case 8:
        return "Six Boundary";

      case 9:
        return "Desperate Boundary";

      case 10:
        return "Desperate Boundary";

      default:
        return "";
    }
  }

  String _getShotCardTitle(int index) {
    switch (index) {
      case 1:
      case 2:
      case 3:
      case 4:
        return "SINGLES";

      case 5:
      case 6:
        return "FOUR";

      case 7:
      case 8:
        return "SIX";

      case 9:
      case 10:
        return "BOUNDARY";

      default:
        return "";
    }
  }

  Widget _getShotSelections() {
    int counter = 1;

    return SizedBox(
        height: 200,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            child: Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var shotCard in _selectedShotGroup!.shotGroup)
                Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: _getShotCardItem(shotCard, counter++))
            ]))));
  }

  Widget _getBottomStrip() {
    return Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.black12))),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _getTeamScore(),
              _getTeamOvers(),
              _getOverBalls(),
              _getBowlers(),
              IconButton(
                  onPressed: () {
                    int type = -1;
                    if (scoreboard!.isBatting == 1)
                      type = 0;
                    else
                      type = 1;
                    Navigator.pushNamed(context, "/scoreboard?teamId=${scoreboard!.teamID}&selectionMode=-1");
                  },
                  icon: const Icon(Icons.settings, size: 30))
            ])));
  }

//Score display.
  Widget _getTeamScore() {
    return Text("${scoreboard!.teamName}-${scoreboard!.totalScore}/${scoreboard!.wickets}", style: const TextStyle(fontSize: 18));
  }

//Over display.
  Widget _getTeamOvers() {
    return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text("Overs: ${scoreboard!.currentOver}.${scoreboard!.currentOverBall}", style: const TextStyle(fontSize: 16)));
  }

//Get current over string for all shots.
  Widget _getOverBalls() {
    return Padding(padding: const EdgeInsets.only(left: 30), child: Text(scoreboard!.currentOverString, style: const TextStyle(fontSize: 16)));
  }

  Widget _getFinalScoreView() {
    String cardLabel = "${scoreboard!.totalScore}/${scoreboard!.wickets}";
    return Column(children: [
      Container(
          color: Colors.brown,
          child: SizedBox(
              width: 150,
              height: 150,
              child: Align(alignment: Alignment.center, child: Text(cardLabel, style: const TextStyle(fontSize: 34, color: Colors.white))))),
    ]);
  }

//Get display as per Score, wicket, WB or NB.
  Widget _getScoreView() {
    String cardLabel = "";
    double? fontSize = 0.0;
    switch (SHOT_TYPE.getByValue(scoreboard!.currentBallShotType)) {
      //Score View,  for 4's 6's and Singles
      case SHOT_TYPE.singles:
      case SHOT_TYPE.four:
      case SHOT_TYPE.six:
      case SHOT_TYPE.db:
        fontSize = 34;
        cardLabel = scoreboard!.currentBallScore.toString();
        break;

      //Wicket View
      case SHOT_TYPE.wicket:
        fontSize = 34;
        cardLabel = "Out!";
        if (scoreboard!.isFreeHit == 1) {
          //If this is free hit, ignore wicket, display score.
          cardLabel = scoreboard!.currentBallScore.toString();
        }
        break;

      // case SHOT_TYPE.tuWicket:
      //   fontSize = 28;
      //   cardLabel = "TU-UMP! \n (OUT)"; //If Third Umpire, DRS, display Third umpire with original decision.
      //   break;

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
      _getPlayOptions()
    ]);
  }

  Widget _getPlayOptions() {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
      //Show 'PLAY' & DRS OPTION
      if (!_isInningOver()) //If inning still running, show play button.
        ElevatedButton(
            onPressed: () async {
              setState(() {
                // if(scoreboard!.currentBallShotType)

                //If bowler is not selected, show bowler selection view.
                if (scoreboard!.currentBowlerType == -1) {
                  _setCurrentView("bs");
                  // _currentView = "bs";
                } else {
                  //if bowler is selected, show delivery selection view.
                  //_currentView = "ds";

                  //if bowler is selected, check if this was the third umpire delivery. but user selected to play
                  if (scoreboard!.currentBallShotType == SHOT_TYPE.tuWicket.value) {
                  } else if (scoreboard!.currentBallShotType == SHOT_TYPE.wicket.value) {
                    // _currentView = "bts";
                    _setCurrentView("bts");
                  } else {
                    //if bowler is selected, show short selection view.
                    // _currentView = "ds";
                    _setCurrentView("ds");
                  }
                }
              });
            },
            child: const Padding(padding: EdgeInsets.all(10), child: Text("Play"))),
      // const SizedBox(width: 10),
      // if (scoreboard!.currentBallShotType == SHOT_TYPE.tuWicket.value)
      //   ElevatedButton(
      //       onPressed: () async {
      //         setState(() {
      //           _currentView = "drs";
      //           // if (scoreboard!.currentBallShotType == SHOT_TYPE.tuWicket.value) {
      //           //   _currentView = "drs";
      //           // }
      //         });
      //       },
      //       child: const Padding(padding: EdgeInsets.all(10), child: Text("DRS")))
    ]);
  }

  Future<bool> _isMatchCompleted() async {
    var scorecardA = await DatabaseService.databaseService.getScorecard("teamA");
    var scorecardB = await DatabaseService.databaseService.getScorecard("teamB");
    if (scorecardA!.isBatting == 2 && scorecardB!.isBatting == 2) {
      return true;
    } else {
      return false;
    }
  }

//Show OB or PB bowlers completed overs & highlight currently playing Bowler type.
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

  bool _isBowlerOverCompleted(int overs) {
    return (overs < (scoreboard!.totalOvers / 2));
  }

  //Set current bowler to Match Scorecard
  Future<void> _setCurrentBowler(int bowlerType, int bowlerId, String teamId) async {
    var scorecard = await DatabaseService.databaseService.getScorecard(teamId);
    setState(() {
      _setCurrentView("ds");
      // _currentView = "ds"; //After showing bowler selection, show delivery selection.
      scoreboard = scorecard; //Current bowler for TeamA
    });
  }

  @override
  bool get wantKeepAlive => true;
}

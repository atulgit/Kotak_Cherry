import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kotak_cherry/data/data_sources/local/services/DatabaseService.dart';

import '../../../data/models/ScoreboardModel.dart';

class MatchWinnerScreen extends StatefulWidget {
  const MatchWinnerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return MatchWinnerState();
  }
}

class MatchWinnerState extends State<MatchWinnerScreen> {
  final player = AudioPlayer();

  ScoreboardModel? scoreboardModelA;
  ScoreboardModel? scoreboardModelB;

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _playWinningSound();
  }

  void _init() async {
    var scorecardA = (await DatabaseService.databaseService.getScorecard("teamA"))!;
    var scorecardB = (await DatabaseService.databaseService.getScorecard("teamB"))!;

    setState(() {
      scoreboardModelA = scorecardA;
      scoreboardModelB = scorecardB;
    });
  }

  void _playWinningSound() {
    player.play(
      AssetSource('audios/a3.wav'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (scoreboardModelA != null && scoreboardModelB != null) {
      return Scaffold(
          body: Material(
              child: Align(
                  alignment: Alignment.center,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                      _getTeamScoreCard(scoreboardModelA!),
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            const Text("Congratulations!!",
                                style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            Text(_getWinnerMessage(), style: const TextStyle(fontSize: 30), textAlign: TextAlign.center)
                          ])),
                      _getTeamScoreCard(scoreboardModelB!)
                    ]),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/create");
                        },
                        child: const Padding(padding: EdgeInsets.all(10), child: Text("Create New Match", style: TextStyle(fontSize: 18))))
                  ]))));
    } else {
      return Container();
    }
  }

  String _getWinnerMessage() {
    if (scoreboardModelA!.totalScore == scoreboardModelB!.totalScore) {
      return "${scoreboardModelA!.teamName} \n Match Ties!";
    } else if (scoreboardModelA!.totalScore > scoreboardModelB!.totalScore) {
      return "${scoreboardModelA!.teamName} \n Won the match!";
    } else {
      return "${scoreboardModelB!.teamName} \n Won the match!";
    }
  }

  Widget _getTeamScoreCard(ScoreboardModel scoreboardModel) {
    return Card(
        child: SizedBox(
            width: 200,
            height: 200,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(scoreboardModel!.teamName, style: const TextStyle(fontSize: 22)),
              Text("${scoreboardModel!.totalScore}/${scoreboardModel.wickets}", style: const TextStyle(fontSize: 22))
            ])));
  }
}

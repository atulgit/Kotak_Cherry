import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/data_sources/local/services/DatabaseService.dart';
import '../../../data/models/ScoreboardModel.dart';
import '../../common/CommonViews.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateMatchState();
  }

}

class CreateMatchState extends State<CreateMatchScreen> {
  final TextEditingController _teamAName = TextEditingController();
  final TextEditingController _teamBName = TextEditingController();
  String _selectedOver = "10";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _teamBName.text = "IND";
    _teamAName.text = "AUS";
    //continueMatch();
  }

  void continueMatch() async {
    var scorecard = await DatabaseService.databaseService.getScorecard("teamA");
    if(scorecard != null) {
      Navigator.pushNamed(context, "/playscreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: 200,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                child: TextFormField(
              controller: _teamAName,
              onTap: () async {},
              decoration: CommonViews.getTextEditFieldDecorator("Team A", null),
              onSaved: (String? value) {},
              // validator: (String? value) {
              //   return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
              // },
            )),
            const SizedBox(height: 20),
            TextFormField(
              controller: _teamBName,
              onTap: () async {},
              decoration: CommonViews.getTextEditFieldDecorator("Team B", null),
              onSaved: (String? value) {},
              // validator: (String? value) {
              //   return (value == null || value.isEmpty) ? 'Date cant be empty.' : null;
              // },
            ),
            const SizedBox(height: 20),
            _getOvers(),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await DatabaseService.databaseService.deleteScorecard("teamA");
                  await DatabaseService.databaseService.deleteScorecard("teamB");

                  ScoreboardModel? teamAScorecard =
                      await DatabaseService.databaseService.createScorecard("teamA", _teamAName.text, int.parse(_selectedOver));
                  ScoreboardModel? teamBScorecard =
                      await DatabaseService.databaseService.createScorecard("teamB", _teamBName.text, int.parse(_selectedOver));

                  Navigator.pushNamed(context, "/playscreen");
                },
                child: const Text("Create Match", style: TextStyle(fontSize: 18)))
          ]))
    ]));
  }

  Widget _getOvers() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.clear();
    menuItems.add(const DropdownMenuItem(value: "-1", child: Text("Select")));
    menuItems.add(const DropdownMenuItem(value: "10", child: Text("10 Overs Match")));
    menuItems.add(const DropdownMenuItem(value: "20", child: Text("20 Overs Match")));
    menuItems.add(const DropdownMenuItem(value: "50", child: Text("50 Overs Match")));

    return Container(
        child: DropdownButtonFormField(
            value: _selectedOver.toString(),
            isExpanded: true,
            items: menuItems,
            validator: (String? value) {
              return (_selectedOver == "-1") ? 'PLease select travel mode.' : null;
            },
            decoration: CommonViews.getDropwDownDecorator("Select Overs", null),
            onChanged: (Object? value) {
              setState(() {
                // _selectedTravelMode = value.toString();
                _selectedOver = value.toString();
              });
            }));
  }
}

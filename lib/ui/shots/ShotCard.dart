import 'dart:collection';

import '../common/Shots.dart';

class ShotCard extends Object {
  SHOT_TYPE primaryShotType = SHOT_TYPE.none;
  String cardName = "";
  String cardTitle = "";
  int cardType = -1; //0-> Defensive (Defensive), 1-> Aggressive(With outs)
  List<Map<String, Shot>> SHOT_CARD = [];

  ShotCard(this.cardTitle, this.cardName, this.SHOT_CARD, {this.cardType = -1, this.primaryShotType = SHOT_TYPE.none});
}

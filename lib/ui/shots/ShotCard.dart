import 'dart:collection';

import '../common/Shots.dart';

class ShotCard {

  String cardName = "";
  String cardTitle = "";
  List<Map<String, Shot>> SHOT_CARD = [];

  ShotCard(this.cardTitle, this.cardName, this.SHOT_CARD);
}
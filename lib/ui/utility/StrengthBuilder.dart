import 'package:kotak_cherry/ui/shots/ShotCard.dart';

import '../common/Shots.dart';

class StrengthBuilder {
  List<Map<String, Shot>> buildStrength(ShotCard shotCard, int batsmanPoints, int bowlerPoints) {
    List<Map<String, Shot>> SHOT_CARD = [];
    shotCard.SHOT_CARD.forEach((element) {
      Shot shot = element["SHOT"]!;
      SHOT_CARD.add({"SHOT": Shot.withCount(shot.value, shot.count, shot.shot_type)});
    });
    ShotCard shotCardStrength =
        ShotCard(shotCard.cardTitle, shotCard.cardName, SHOT_CARD, cardType: shotCard.cardType, primaryShotType: shotCard.primaryShotType);

    // int batsmanPoints = 300;
    // int bowlerPoints = 180;

    // double probabilityCount = shotObj.count.toDouble();

    int diff = (batsmanPoints - bowlerPoints);
    double strength = diff / 3; //Convert difference points to strength boxes. 1 strength box consists of three points.

    String strengthTeam = _checkIfBatsmanOrBowlerStrength(strength);

    if (strengthTeam == "BAT") {
      //If BAT team gains strength, increase runs, decrease outs or db.
      //Find out the max number of outs or db, which can be decreased.
      //Then check if max number of outs or db which can be decreased are < gained strength. if yes, then consider strength as max outs or db.
      //if not, then consider actual strength.

      if (shotCardStrength.cardType == 0) {
        strength = _getMaxStrengthForBatsman(strength, shotCardStrength);
        shotCardStrength.SHOT_CARD = _getRunsIncreasedStrengthShotGroup(shotCardStrength, strength);
        shotCardStrength.SHOT_CARD = _getDBDecreasedStrengthShotGroup(shotCardStrength, strength);
      } else if (shotCardStrength.cardType == 1) {
        strength = _getMaxStrengthForBatsman(strength, shotCardStrength);
        shotCardStrength.SHOT_CARD = _getRunsIncreasedStrengthShotGroup(shotCardStrength, strength);
        shotCardStrength.SHOT_CARD = _getWicketsDecreasedStrengthShotGroup(shotCardStrength, strength);
      }
    } else if (strengthTeam == "BOW") {
      //IF BOWL team gains strength, decrease runs, increase outs or db.
      //find out the max number of runs that can be decreased.
      //then check if max number of runs than can be decreased are < bowler strength, if yes then, consider bowler strength as max runs.
      //if no, then consider actual strength

      if (shotCardStrength.cardType == 0) {
        //IF DB card type (Defensive).
        strength = _getMaxStrengthForBowler(strength, shotCardStrength);
        shotCardStrength.SHOT_CARD = _getRunsDecreasedStrengthShotGroup(shotCardStrength, strength);
        shotCardStrength.SHOT_CARD = _getDBIncreasedStrengthShotGroup(shotCardStrength, strength);
      } else if (shotCardStrength.cardType == 1) {
        //id Wicket card type (Aggressive)
        strength = _getMaxStrengthForBowler(strength, shotCardStrength);
        shotCardStrength.SHOT_CARD = _getRunsDecreasedStrengthShotGroup(shotCardStrength, strength);
        shotCardStrength.SHOT_CARD = _getWicketsIncreasedStrengthShotGroup(shotCardStrength, strength);
      }
    } else {
      //If no team gains strength
    }

    return shotCardStrength.SHOT_CARD;
  }

  double _getMaxStrengthForBatsman(double strength, ShotCard shotCard) {
    int shotCount = 0;
    if (shotCard.cardType == 0) {
      shotCount = _getShotGroup(shotCard, SHOT_TYPE.db).count;
    } else if (shotCard.cardType == 1) {
      shotCount = _getShotGroup(shotCard, SHOT_TYPE.wicket).count;
    }
    if (strength > shotCount) {
      strength = shotCount.toDouble();
    }

    return strength.abs().roundToDouble();
  }

  double _getMaxStrengthForBowler(double strength, ShotCard shotCard) {
    int shotCount = 0;
    shotCount = _getShotGroup(shotCard, shotCard.primaryShotType).count;
    if (strength.abs() > shotCount) {
      strength = shotCount.toDouble();
    }

    return strength.abs().roundToDouble();
  }

  List<Map<String, Shot>> _getWicketsIncreasedStrengthShotGroup(ShotCard shotCard, double strength) {
    List<Map<String, Shot>> shotMaps = shotCard.SHOT_CARD!;
    for (var shotMap in shotMaps) {
      if (shotMap["SHOT"]!.shot_type == SHOT_TYPE.wicket) {
        shotMap["SHOT"]!.count += strength.toInt();
      }
    }

    return shotMaps;
  }

  List<Map<String, Shot>> _getWicketsDecreasedStrengthShotGroup(ShotCard shotCard, double strength) {
    List<Map<String, Shot>> shotMaps = shotCard.SHOT_CARD!;
    for (var shotMap in shotMaps) {
      if (shotMap["SHOT"]!.shot_type == SHOT_TYPE.wicket) {
        shotMap["SHOT"]!.count -= strength.toInt();
      }
    }

    return shotMaps;
  }

  List<Map<String, Shot>> _getRunsIncreasedStrengthShotGroup(ShotCard shotCard, double strength) {
    List<Map<String, Shot>> shotMaps = shotCard.SHOT_CARD!;
    for (var shotMap in shotMaps) {
      if (shotMap["SHOT"]!.shot_type == SHOT_TYPE.singles ||
          shotMap["SHOT"]!.shot_type == SHOT_TYPE.four ||
          shotMap["SHOT"]!.shot_type == SHOT_TYPE.six) {
        shotMap["SHOT"]!.count += strength.toInt();
      }
    }

    return shotMaps;
  }

  List<Map<String, Shot>> _getDBIncreasedStrengthShotGroup(ShotCard shotCard, double strength) {
    List<Map<String, Shot>> shotMaps = shotCard.SHOT_CARD!;
    for (var shotMap in shotMaps) {
      if (shotMap["SHOT"]!.shot_type == SHOT_TYPE.db) {
        shotMap["SHOT"]!.count += strength.toInt();
      }
    }

    return shotMaps;
  }

  List<Map<String, Shot>> _getDBDecreasedStrengthShotGroup(ShotCard shotCard, double strength) {
    List<Map<String, Shot>> shotMaps = shotCard.SHOT_CARD!;
    for (var shotMap in shotMaps) {
      if (shotMap["SHOT"]!.shot_type == SHOT_TYPE.db) {
        shotMap["SHOT"]!.count -= strength.toInt();
      }
    }

    return shotMaps;
  }

  List<Map<String, Shot>> _getRunsDecreasedStrengthShotGroup(ShotCard shotCard, double strength) {
    List<Map<String, Shot>> shotMaps = shotCard.SHOT_CARD!;
    for (var shotMap in shotMaps) {
      if (shotMap["SHOT"]!.shot_type == SHOT_TYPE.singles ||
          shotMap["SHOT"]!.shot_type == SHOT_TYPE.four ||
          shotMap["SHOT"]!.shot_type == SHOT_TYPE.six) {
        shotMap["SHOT"]!.count -= strength.toInt();
      }
    }

    return shotMaps;
  }

  Shot _getShotGroup(ShotCard shotCard, SHOT_TYPE shotType) {
    Map<String, Shot> shotGrpDB = shotCard.SHOT_CARD.where((element) {
      return element["SHOT"]!.shot_type == shotType;
    }).single;

    return shotGrpDB["SHOT"]!;
  }

  String _checkIfBatsmanOrBowlerStrength(double strength) {
    if (strength > 0) {
      return "BAT";
    } else if (strength < 0) {
      return "BOW";
    } else {
      return "NA";
    }
  }
}

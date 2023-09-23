import 'dart:collection';

import '../../common/Shots.dart';
import '../ShotCard.dart';

mixin SC_SIXES {
  static ShotCard SHOT_CARD_SC1_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 0, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 180, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC1_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 50, SHOT_TYPE.six)}),
        HashMap.of({"SHOT": Shot.withCount("O", 130, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC2_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 0, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("O", 180, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC2_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 60, SHOT_TYPE.six)}),
        HashMap.of({"SHOT": Shot.withCount("O", 120, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC3_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 10, SHOT_TYPE.six)}), //Shot Group
        // HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 170, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC3_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 65, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 5, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 110, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC4_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 25, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 5, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 150, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC4_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 70, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 100, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);
}

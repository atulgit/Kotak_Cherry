import 'dart:collection';

import '../../common/Shots.dart';
import '../ShotCard.dart';

mixin SC_SIXES {
  static ShotCard SHOT_CARD_SC1_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 10, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 170, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC1_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 85, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 5, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 90, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC2_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 25, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 5, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 150, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC2_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 90, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 80, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC3_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 40, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 130, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC3_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 90, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 20, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 70, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC4_DB = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 50, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 20, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 110, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.six);

  static ShotCard SHOT_CARD_SC4_OUT = ShotCard(
      "SINGLES",
      "Three's",
      [
        HashMap.of({"SHOT": Shot.withCount("6", 90, SHOT_TYPE.six)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 30, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 60, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.six);
}

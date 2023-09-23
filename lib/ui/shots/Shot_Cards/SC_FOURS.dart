import 'dart:collection';

import '../../common/Shots.dart';
import '../ShotCard.dart';

mixin SC_FOURS {
  static ShotCard SHOT_CARD_SC1_DB = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 0, SHOT_TYPE.four)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("0", 180, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC1_OUT = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 70, SHOT_TYPE.four)}), //Shot Grou
        HashMap.of({"SHOT": Shot.withCount("O", 110, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC2_DB = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 10, SHOT_TYPE.four)}), //Shot G
        HashMap.of({"SHOT": Shot.withCount("O", 170, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC2_OUT = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 75, SHOT_TYPE.four)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 5, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 100, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC3_DB = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 25, SHOT_TYPE.four)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 5, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 150, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC3_OUT = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 80, SHOT_TYPE.four)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 90, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC4_DB = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 40, SHOT_TYPE.four)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.wb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 130, SHOT_TYPE.db)})
      ],
      cardType: 0,
      primaryShotType: SHOT_TYPE.four);

  static ShotCard SHOT_CARD_SC4_OUT = ShotCard(
      "SINGLES",
      "Four's",
      [
        HashMap.of({"SHOT": Shot.withCount("4", 80, SHOT_TYPE.four)}), //Shot Group
        HashMap.of({"SHOT": Shot.withCount("1", 20, SHOT_TYPE.nb)}),
        HashMap.of({"SHOT": Shot.withCount("O", 80, SHOT_TYPE.wicket)})
      ],
      cardType: 1,
      primaryShotType: SHOT_TYPE.four);
}

import 'dart:collection';

import '../../common/Shots.dart';
import '../ShotCard.dart';

mixin SC_ONES {
  static ShotCard SHOT_CARD_SC1_DB = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 40, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 10, SHOT_TYPE.wb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 130, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC1_OUT = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 110, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 20, SHOT_TYPE.nb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 50, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_SC2_DB = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 50, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 20, SHOT_TYPE.wb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 110, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC2_OUT = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 100, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 30, SHOT_TYPE.nb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 40, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_SC3_DB = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 60, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 30, SHOT_TYPE.wb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 90, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC3_OUT = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 110, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 40, SHOT_TYPE.nb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 30, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_SC4_DB = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 70, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 40, SHOT_TYPE.wb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 70, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC4_OUT = ShotCard("SINGLES", "One's", [
    HashMap.of({"SHOT": Shot.withCount("1", 110, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"SHOT": Shot.withCount("1", 50, SHOT_TYPE.nb)}),
    HashMap.of({"SHOT": Shot.withCount("O", 20, SHOT_TYPE.wicket)})
  ]);
}
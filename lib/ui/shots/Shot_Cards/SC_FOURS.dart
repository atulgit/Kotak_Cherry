import 'dart:collection';

import '../../common/Shots.dart';
import '../ShotCard.dart';

mixin SC_FOURS {
  static ShotCard SHOT_CARD_SC1_DB = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 10, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 170, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC1_OUT = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 85, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 5, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 90, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_SC2_DB = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 25, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 5, SHOT_TYPE.wb)}),
    HashMap.of({"L1": Shot.withCount("O", 150, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC2_OUT = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 90, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 10, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 80, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_SC3_DB = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 40, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 10, SHOT_TYPE.wb)}),
    HashMap.of({"L1": Shot.withCount("O", 130, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC3_OUT = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 90, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 20, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 70, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_SC4_DB = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 50, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 20, SHOT_TYPE.wb)}),
    HashMap.of({"L1": Shot.withCount("O", 110, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_SC4_OUT = ShotCard("SINGLES", "Four's", [
    HashMap.of({"L1": Shot.withCount("3", 90, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 30, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 60, SHOT_TYPE.wicket)})
  ]);
}

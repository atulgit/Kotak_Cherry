import 'dart:collection';

import '../common/Shots.dart';
import 'GroupShots.dart';
import 'ShotCard.dart';

mixin OBShotCards {
  static ShotCard SHOT_CARD_1 = ShotCard("SINGLES", "One's", [
    HashMap.of({"L1": Shot.withCount("1", 40, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("1", 10, SHOT_TYPE.wb)}),
    HashMap.of({"L1": Shot.withCount("O", 130, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_2 = ShotCard("SINGLES", "Two's", [
    HashMap.of({"L1": Shot.withCount("2", 25, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("1", 5, SHOT_TYPE.wb)}),
    HashMap.of({"L1": Shot.withCount("0", 150, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_3 = ShotCard("SINGLES", "Three's", [
    HashMap.of({"L1": Shot.withCount("3", 10, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("0", 170, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_4 = ShotCard("BOUNDARY", "Four's", [
    HashMap.of({"L1": Shot.withCount("0", 180, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_5 = ShotCard("BOUNDARY", "Six's", [
    HashMap.of({"L1": Shot.withCount("0", 180, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_6 = ShotCard("SINGLES", "One's", [
    HashMap.of({"L1": Shot.withCount("1", 110, SHOT_TYPE.singles)}), //CARD SLOT - L1/L2/L3
    HashMap.of({"L1": Shot.withCount("1", 20, SHOT_TYPE.nb)}), //CARD SLOT - L1/L2/L3
    HashMap.of({"L1": Shot.withCount("O", 50, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_7 = ShotCard("SINGLES", "Two's", [
    HashMap.of({"L1": Shot.withCount("2", 100, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("1", 10, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 70, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_8 = ShotCard("SINGLES", "Three's", [
    HashMap.of({"L1": Shot.withCount("2", 85, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("1", 5, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 90, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_9 = ShotCard("BOUNDARY", "Four's", [
    HashMap.of({"L1": Shot.withCount("4", 70, SHOT_TYPE.four)}),
    HashMap.of({"L1": Shot.withCount("O", 110, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_10 = ShotCard("BOUNDARY", "Six's", [
    HashMap.of({"L1": Shot.withCount("6", 50, SHOT_TYPE.six)}),
    HashMap.of({"L1": Shot.withCount("O", 130, SHOT_TYPE.wicket)})
  ]);

  static Map<String, List<GroupShots>> SHOT_CARD_GROUPS = {
    "L1": [
      GroupShots("ONE's", [SHOT_CARD_1, SHOT_CARD_6]),
      GroupShots("TWO's", [SHOT_CARD_2, SHOT_CARD_7]),
      GroupShots("THREE's", [SHOT_CARD_3, SHOT_CARD_8]),
      GroupShots("FOUR's", [SHOT_CARD_4, SHOT_CARD_9]),
      GroupShots("SIX's", [SHOT_CARD_5, SHOT_CARD_10]),
    ],
    "L2": [
      GroupShots("SINGLES", [SHOT_CARD_1, SHOT_CARD_6, SHOT_CARD_2, SHOT_CARD_7, SHOT_CARD_3, SHOT_CARD_8]),
      GroupShots("FOUR's", [SHOT_CARD_4, SHOT_CARD_9]),
      GroupShots("SIX's", [SHOT_CARD_5, SHOT_CARD_10])
    ],
    "L3": [
      GroupShots("SINGLES", [SHOT_CARD_1, SHOT_CARD_6, SHOT_CARD_2, SHOT_CARD_7, SHOT_CARD_3, SHOT_CARD_8]),
      GroupShots("BOUNDARY", [SHOT_CARD_4, SHOT_CARD_9, SHOT_CARD_5, SHOT_CARD_10]),
    ]
  };
}

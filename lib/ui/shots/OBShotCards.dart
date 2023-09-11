import 'dart:collection';

import '../common/Shots.dart';
import 'GroupShots.dart';
import 'ShotCard.dart';

mixin OBShotCards {
  // static List<List<Map<String, Shot>>> SHOT_CARDS = [
  //   SHOT_CARD_1,
  //   SHOT_CARD_2,
  //   SHOT_CARD_3,
  //   SHOT_CARD_4,
  //   SHOT_CARD_5,
  //   SHOT_CARD_6,
  //   SHOT_CARD_7,
  //   SHOT_CARD_8,
  //   SHOT_CARD_9,
  //   SHOT_CARD_10
  // ];

  // static ShotCard SHOT_CARD_1 = ShotCard("SINGLES", "Safe Singles", [
  //   HashMap.of({"L1": Shot.withCount("0", 12, SHOT_TYPE.singles)}), //Shot Group
  //   HashMap.of({"L1": Shot.withCount("1", 18, SHOT_TYPE.singles)}),
  //   HashMap.of({"L1": Shot.withCount("2", 6, SHOT_TYPE.singles)})
  // ]);



  //Temp
  static ShotCard SHOT_CARD_1 = ShotCard("SINGLES", "Safe Singles", [
    HashMap.of({"L1": Shot.withCount("1", 50, SHOT_TYPE.singles)}), //Shot Group
    HashMap.of({"L1": Shot.withCount("O", 50, SHOT_TYPE.db)})
  ]);

  static ShotCard SHOT_CARD_2 = ShotCard("SINGLES", "Some More Singles", [
    HashMap.of({"L1": Shot.withCount("0", 12, SHOT_TYPE.db)}),
    HashMap.of({"L1": Shot.withCount("1", 6, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("2", 6, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("3", 6, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("2", 6, SHOT_TYPE.nb)})
  ]);

  // static List<Map<String, Shot>> SHOT_CARD_2 = [
  //   HashMap.of({"L1": Shot.withCount("1", 6, SHOT_TYPE.wicket)}),
  //   HashMap.of({"L1": Shot.withCount("2", 12, SHOT_TYPE.wicket)}),
  //   HashMap.of({"L1": Shot.withCount("3", 6, SHOT_TYPE.wicket)}),
  //   HashMap.of({"L1": Shot.withCount("0", 12, SHOT_TYPE.wicket)})
  // ];

  static ShotCard SHOT_CARD_3 = ShotCard("SINGLES", "Desperate Singles", [
    HashMap.of({"L1": Shot.withCount("1", 12, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("2", 6, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("3", 12, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("O", 6, SHOT_TYPE.tuWicket)})
  ]);

  static ShotCard SHOT_CARD_4 = ShotCard("SINGLES", "Relaxed Score", [
    HashMap.of({"L1": Shot.withCount("0", 18, SHOT_TYPE.db)}),
    HashMap.of({"L1": Shot.withCount("1", 6, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("3", 6, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("1", 6, SHOT_TYPE.nb)})
  ]);

  static ShotCard SHOT_CARD_5 = ShotCard("FOUR", "Try Four", [
    HashMap.of({"L1": Shot.withCount("0", 12, SHOT_TYPE.db)}),
    HashMap.of({"L1": Shot.withCount("2", 12, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("4", 12, SHOT_TYPE.four)})
  ]);

  static ShotCard SHOT_CARD_6 = ShotCard("FOUR", "Four Boundary", [
    HashMap.of({"L1": Shot.withCount("0", 12, SHOT_TYPE.db)}), //CARD SLOT - L1/L2/L3
    HashMap.of({"L1": Shot.withCount("4", 12, SHOT_TYPE.four)}), //CARD SLOT - L1/L2/L3
    HashMap.of({"L1": Shot.withCount("4", 6, SHOT_TYPE.nb)}),
    HashMap.of({"L1": Shot.withCount("O", 6, SHOT_TYPE.tuWicket)})
  ]);

  static ShotCard SHOT_CARD_7 = ShotCard("SIX", "Try Six", [
    HashMap.of({"L1": Shot.withCount("0", 24, SHOT_TYPE.db)}),
    HashMap.of({"L1": Shot.withCount("6", 12, SHOT_TYPE.six)})
  ]);

  static ShotCard SHOT_CARD_8 = ShotCard("SIX", "Six Boundary", [
    HashMap.of({"L1": Shot.withCount("2", 12, SHOT_TYPE.singles)}),
    HashMap.of({"L1": Shot.withCount("6", 18, SHOT_TYPE.six)}),
    HashMap.of({"L1": Shot.withCount("O", 6, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_9 = ShotCard("BOUNDARY", "Desperate Boundary", [
    HashMap.of({"L1": Shot.withCount("2", 18, SHOT_TYPE.four)}),
    HashMap.of({"L1": Shot.withCount("6", 12, SHOT_TYPE.six)}),
    HashMap.of({"L1": Shot.withCount("R", 6, SHOT_TYPE.wicket)})
  ]);

  static ShotCard SHOT_CARD_10 = ShotCard("BOUNDARY", "Desperate Boundary", [
    HashMap.of({"L1": Shot.withCount("4", 12, SHOT_TYPE.four)}),
    HashMap.of({"L1": Shot.withCount("6", 18, SHOT_TYPE.six)}),
    HashMap.of({"L1": Shot.withCount("O", 6, SHOT_TYPE.wicket)})
  ]);

  // static List<Map<String, Shot>> DRS_CARD_TH_UMPIRE = [
  //   HashMap.of({"L1": Shot.withCount("0", 2, SHOT_TYPE.db)}),
  //   HashMap.of({"L1": Shot.withCount("0", 4, SHOT_TYPE.wicket)})
  // ];

  static Map<String, List<GroupShots>> SHOT_CARD_GROUPS = {
    "L1": [
      GroupShots("DEFENSIVE 1", [SHOT_CARD_1, SHOT_CARD_5, SHOT_CARD_7]),
      GroupShots("DEFENSIVE 2", [SHOT_CARD_2, SHOT_CARD_6, SHOT_CARD_8]),
      GroupShots("AGGRESSIVE 1", [SHOT_CARD_3, SHOT_CARD_9]),
      GroupShots("AGGRESSIVE 2", [SHOT_CARD_4, SHOT_CARD_10])
    ],
    // "L2": [[], [], []],
    // "L3": [[], []]
  };
}

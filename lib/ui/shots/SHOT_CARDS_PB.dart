import 'dart:collection';

import 'GroupShots.dart';
import 'ShotCard.dart';
import 'Shot_Cards/SC_ONES.dart';
import 'Shot_Cards/SC_THREES.dart';
import 'Shot_Cards/SC_TWOS.dart';

mixin SHOT_CARDS_PB {
  static final HashMap<String, ShotCard> _SHOT_CARDS_ONES_DB =
  HashMap.of({"L1": SC_ONES.SHOT_CARD_SC2_DB, "L2": SC_ONES.SHOT_CARD_SC3_DB, "L3": SC_ONES.SHOT_CARD_SC4_DB});

  static final HashMap<String, ShotCard> _SHOT_CARDS_ONES_OUT =
  HashMap.of({"L1": SC_ONES.SHOT_CARD_SC2_OUT, "L2": SC_ONES.SHOT_CARD_SC3_OUT, "L3": SC_ONES.SHOT_CARD_SC4_OUT});

  static final HashMap<String, ShotCard> _SHOT_CARDS_TWOS_DB =
  HashMap.of({"L1": SC_TWOS.SHOT_CARD_SC2_DB, "L2": SC_TWOS.SHOT_CARD_SC3_DB, "L3": SC_TWOS.SHOT_CARD_SC4_DB});

  static final HashMap<String, ShotCard> _SHOT_CARDS_TWOS_OUT =
  HashMap.of({"L1": SC_TWOS.SHOT_CARD_SC2_OUT, "L2": SC_TWOS.SHOT_CARD_SC3_OUT, "L3": SC_TWOS.SHOT_CARD_SC4_OUT});

  static final HashMap<String, ShotCard> _SHOT_CARDS_THREE_DB =
  HashMap.of({"L1": SC_THREES.SHOT_CARD_SC2_DB, "L2": SC_THREES.SHOT_CARD_SC3_DB, "L3": SC_THREES.SHOT_CARD_SC4_DB});

  static final HashMap<String, ShotCard> _SHOT_CARDS_THREES_OUT =
  HashMap.of({"L1": SC_THREES.SHOT_CARD_SC2_OUT, "L2": SC_THREES.SHOT_CARD_SC3_OUT, "L3": SC_THREES.SHOT_CARD_SC4_OUT});

  static Map<String, List<GroupShots>> SHOT_CARD_GROUPS = {
    "L1": [
      GroupShots("ONE's", [SHOT_CARDS_PB._SHOT_CARDS_ONES_DB["L1"]!, SHOT_CARDS_PB._SHOT_CARDS_ONES_OUT["L1"]!]),
      GroupShots("TWO's", [SHOT_CARDS_PB._SHOT_CARDS_TWOS_DB["L1"]!, SHOT_CARDS_PB._SHOT_CARDS_TWOS_OUT["L1"]!]),
      GroupShots("THREE's", [SHOT_CARDS_PB._SHOT_CARDS_THREE_DB["L1"]!, SHOT_CARDS_PB._SHOT_CARDS_THREES_OUT["L1"]!]),
      // GroupShots("FOUR's", [SHOT_CARD_4, SHOT_CARD_9]),
      // GroupShots("SIX's", [SHOT_CARD_5, SHOT_CARD_10]),
    ],
    "L2": [
      GroupShots("SINGLES", [
        SHOT_CARDS_PB._SHOT_CARDS_ONES_DB["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_ONES_OUT["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_TWOS_DB["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_TWOS_OUT["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_THREE_DB["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_THREES_OUT["L2"]!,
      ]),
      // GroupShots("FOUR's", [SHOT_CARD_4, SHOT_CARD_9]),
      // GroupShots("SIX's", [SHOT_CARD_5, SHOT_CARD_10])
    ],
    "L3": [
      GroupShots("SINGLES", [
        SHOT_CARDS_PB._SHOT_CARDS_ONES_DB["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_ONES_OUT["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_TWOS_DB["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_TWOS_OUT["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_THREE_DB["L2"]!,
        SHOT_CARDS_PB._SHOT_CARDS_THREES_OUT["L2"]!,
      ]),
      //GroupShots("BOUNDARY", [SHOT_CARD_4, SHOT_CARD_9, SHOT_CARD_5, SHOT_CARD_10]),
    ]
  };
}
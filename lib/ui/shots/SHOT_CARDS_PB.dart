import 'dart:collection';

import 'GroupShots.dart';
import 'SHOT_CARDS_OB.dart';
import 'ShotCard.dart';
import 'Shot_Cards/SC_FOURS.dart';
import 'Shot_Cards/SC_ONES.dart';
import 'Shot_Cards/SC_SIXES.dart';
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

  static final HashMap<String, ShotCard> _SHOT_CARDS_FOUR_DB =
      HashMap.of({"L1": SC_FOURS.SHOT_CARD_SC2_DB, "L2": SC_FOURS.SHOT_CARD_SC3_DB, "L3": SC_FOURS.SHOT_CARD_SC4_DB});

  static final HashMap<String, ShotCard> _SHOT_CARDS_FOUR_OUT =
      HashMap.of({"L1": SC_FOURS.SHOT_CARD_SC2_OUT, "L2": SC_FOURS.SHOT_CARD_SC3_OUT, "L3": SC_FOURS.SHOT_CARD_SC4_OUT});

  static final HashMap<String, ShotCard> _SHOT_CARDS_SIX_DB =
      HashMap.of({"L1": SC_SIXES.SHOT_CARD_SC2_DB, "L2": SC_SIXES.SHOT_CARD_SC3_DB, "L3": SC_SIXES.SHOT_CARD_SC4_DB});

  static final HashMap<String, ShotCard> _SHOT_CARDS_SIX_OUT =
      HashMap.of({"L1": SC_SIXES.SHOT_CARD_SC2_OUT, "L2": SC_SIXES.SHOT_CARD_SC3_OUT, "L3": SC_SIXES.SHOT_CARD_SC4_OUT});

  static Map<String, List<GroupShots>> SHOT_CARD_GROUPS = {
    //When L1 batsman, below are the shot selection available. Shots are divided into five groups for L1 batsman.
    "L1": [
      GroupShots("ONE's", [_SHOT_CARDS_ONES_DB["L1"]!, _SHOT_CARDS_ONES_OUT["L1"]!]),
      GroupShots("TWO's", [_SHOT_CARDS_TWOS_DB["L1"]!, _SHOT_CARDS_TWOS_OUT["L1"]!]),
      GroupShots("THREE's", [_SHOT_CARDS_THREE_DB["L1"]!, _SHOT_CARDS_THREES_OUT["L1"]!]),
      GroupShots("FOUR's", [_SHOT_CARDS_FOUR_DB["L1"]!, _SHOT_CARDS_FOUR_OUT["L1"]!]),
      GroupShots("SIX's", [_SHOT_CARDS_SIX_DB["L1"]!, _SHOT_CARDS_SIX_OUT["L1"]!])
    ],
    //When L2 batsman, below are the shot selection available. Shots are divided into three(singles, 4's and 6's) groups for L2 batsman.
    "L2": [
      GroupShots("SINGLES", [
        _SHOT_CARDS_ONES_DB["L2"]!,
        _SHOT_CARDS_ONES_OUT["L2"]!,
        _SHOT_CARDS_TWOS_DB["L2"]!,
        _SHOT_CARDS_TWOS_OUT["L2"]!,
        _SHOT_CARDS_THREE_DB["L2"]!,
        _SHOT_CARDS_THREES_OUT["L2"]!,
      ]),
      GroupShots("FOUR's", [_SHOT_CARDS_FOUR_DB["L2"]!, _SHOT_CARDS_FOUR_OUT["L2"]!]),
      GroupShots("SIX's", [_SHOT_CARDS_SIX_DB["L2"]!, _SHOT_CARDS_SIX_OUT["L2"]!])
    ],
    //When L3 batsman, below are the shot selection available. Shots are divided into two(singles, boundaries of 4's and 6's) groups for L2 batsman.
    "L3": [
      GroupShots("SINGLES", [
        _SHOT_CARDS_ONES_DB["L3"]!,
        _SHOT_CARDS_ONES_OUT["L3"]!,
        _SHOT_CARDS_TWOS_DB["L3"]!,
        _SHOT_CARDS_TWOS_OUT["L3"]!,
        _SHOT_CARDS_THREE_DB["L3"]!,
        _SHOT_CARDS_THREES_OUT["L3"]!,
      ]),
      GroupShots("BOUNDARY", [_SHOT_CARDS_FOUR_DB["L3"]!, _SHOT_CARDS_FOUR_OUT["L3"]!, _SHOT_CARDS_SIX_DB["L3"]!, _SHOT_CARDS_SIX_OUT["L3"]!]),
    ]
  };
}

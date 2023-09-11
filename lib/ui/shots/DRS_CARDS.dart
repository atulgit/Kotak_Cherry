import 'dart:collection';

import '../common/Shots.dart';

mixin DRS_CARDS {
  static List<Map<String, Shot>> DRS_CARD_MAX_OUT = [
    HashMap.of({"L1": Shot.withCount("N", 2, SHOT_TYPE.db)}),
    HashMap.of({"L1": Shot.withCount("O", 4, SHOT_TYPE.wicket)})
  ];

  static List<Map<String, Shot>> DRS_CARD_MAX_NOT_OUT = [
    HashMap.of({"L1": Shot.withCount("N", 4, SHOT_TYPE.db)}),
    HashMap.of({"L1": Shot.withCount("O", 2, SHOT_TYPE.wicket)})
  ];

// static List<Map<String, Shot>> DRS_CARD_OB_BOWL = [
//   HashMap.of({"L1": Shot.withCount("0", 2, SHOT_TYPE.db)}),
//   HashMap.of({"L1": Shot.withCount("0", 4, SHOT_TYPE.wicket)})
// ];
//
// static List<Map<String, Shot>> DRS_CARD_PB_BOWL = [
//   HashMap.of({"L1": Shot.withCount("0", 2, SHOT_TYPE.db)}),
//   HashMap.of({"L1": Shot.withCount("0", 4, SHOT_TYPE.wicket)})
// ];
}

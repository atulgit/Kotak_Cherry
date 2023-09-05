mixin Shots {
  static List<Shot> SHOT_1 = [
    Shot("1", SHOT_TYPE.singles),
    Shot("2", SHOT_TYPE.singles),
    Shot("4", SHOT_TYPE.four),
    Shot("Out", SHOT_TYPE.wicket),
    Shot("6", SHOT_TYPE.six)
  ];

  static List<Shot> SHOT_2 = [];

  static List<Shot> SHOT_3 = [];

  static List<Shot> SHOT_4 = [];

  static List<Shot> SHOT_5 = [];

  static List<Shot> SHOT_6 = [];

  static List<Shot> SHOT_7 = [];
}

class Shot {
  String value = "";
  SHOT_TYPE shot_type = SHOT_TYPE.none;

  Shot(this.value, this.shot_type);
}

enum SHOT_TYPE {
  none(0),
  singles(1),
  four(2),
  six(3),
  nb(4),
  wicket(5),
  tuWicket(6),
  db(7),
  wb(8);

  const SHOT_TYPE(this.value);

  final int value;

  static SHOT_TYPE getByValue(num i) {
    return SHOT_TYPE.values.firstWhere((x) => x.value == i);
  }
}

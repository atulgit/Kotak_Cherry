import '../common/Shots.dart';

mixin PBShots {
  static List<List<Shot>> SHOTS = [SHOT_1, SHOT_2, SHOT_3, SHOT_4, SHOT_5, SHOT_6, SHOT_7, SHOT_8, SHOT_9, SHOT_10];

  // static List<Shot> SHOT_1 = [
  //   Shot("1", SHOT_TYPE.singles),
  //   Shot("1", SHOT_TYPE.singles),
  //   Shot("1", SHOT_TYPE.singles),
  //   Shot("O", SHOT_TYPE.db),
  //   Shot("0", SHOT_TYPE.db),
  //   Shot("2", SHOT_TYPE.singles)
  // ];

  static List<Shot> SHOT_1 = [
    Shot("O", SHOT_TYPE.tuWicket),
    Shot("O", SHOT_TYPE.tuWicket),
    Shot("O", SHOT_TYPE.tuWicket),
    Shot("O", SHOT_TYPE.tuWicket),
    Shot("O", SHOT_TYPE.tuWicket),
    Shot("O", SHOT_TYPE.tuWicket)
  ];

  static List<Shot> SHOT_2 = [
    Shot("NO", SHOT_TYPE.tuWicket),
    Shot("NO", SHOT_TYPE.tuWicket),
    Shot("NO", SHOT_TYPE.tuWicket),
    Shot("NO", SHOT_TYPE.tuWicket),
    Shot("NO", SHOT_TYPE.tuWicket),
    Shot("NO", SHOT_TYPE.tuWicket)
  ];

  // static List<Shot> SHOT_2 = [
  //   Shot("2", SHOT_TYPE.nb),
  //   Shot("2", SHOT_TYPE.singles),
  //   Shot("1", SHOT_TYPE.singles),
  //   Shot("3", SHOT_TYPE.singles),
  //   Shot("0", SHOT_TYPE.db),
  //   Shot("0", SHOT_TYPE.db)
  // ];

  static List<Shot> SHOT_3 = [
    Shot("3", SHOT_TYPE.singles),
    Shot("3", SHOT_TYPE.singles),
    Shot("2", SHOT_TYPE.singles),
    Shot("1", SHOT_TYPE.singles),
    Shot("1", SHOT_TYPE.singles),
    Shot("NO", SHOT_TYPE.tuWicket)
  ];

  static List<Shot> SHOT_4 = [
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("1", SHOT_TYPE.singles),
    Shot("nb", SHOT_TYPE.nb),
    Shot("3", SHOT_TYPE.singles)
  ];

  static List<Shot> SHOT_5 = [
    Shot("4", SHOT_TYPE.four),
    Shot("4", SHOT_TYPE.four),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("2", SHOT_TYPE.singles),
    Shot("2", SHOT_TYPE.singles)
  ];

  static List<Shot> SHOT_6 = [
    Shot("4", SHOT_TYPE.nb),
    Shot("4", SHOT_TYPE.four),
    Shot("4", SHOT_TYPE.four),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("O", SHOT_TYPE.tuWicket)
  ];

  static List<Shot> SHOT_7 = [
    Shot("6", SHOT_TYPE.six),
    Shot("6", SHOT_TYPE.six),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db)
  ];

  static List<Shot> SHOT_8 = [
    Shot("6", SHOT_TYPE.six),
    Shot("6", SHOT_TYPE.six),
    Shot("6", SHOT_TYPE.six),
    Shot("2", SHOT_TYPE.singles),
    Shot("2", SHOT_TYPE.singles),
    Shot("out", SHOT_TYPE.wicket)
  ];

  static List<Shot> SHOT_9 = [
    Shot("6", SHOT_TYPE.six),
    Shot("6", SHOT_TYPE.six),
    Shot("4", SHOT_TYPE.four),
    Shot("4", SHOT_TYPE.four),
    Shot("4", SHOT_TYPE.four),
    Shot("R", SHOT_TYPE.wicket)
  ];

  static List<Shot> SHOT_10 = [
    Shot("6", SHOT_TYPE.six),
    Shot("6", SHOT_TYPE.six),
    Shot("6", SHOT_TYPE.six),
    Shot("4", SHOT_TYPE.four),
    Shot("4", SHOT_TYPE.four),
    Shot("O", SHOT_TYPE.wicket)
  ];

  static List<Shot> THIRD_UMPIRE = [
    Shot("0", SHOT_TYPE.wicket),
    Shot("0", SHOT_TYPE.wicket),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db),
    Shot("0", SHOT_TYPE.db)
  ];
}

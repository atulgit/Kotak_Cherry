enum PRIORITY {
  P0(0),
  P1(1),
  P2(2),
  P3(3);

  const PRIORITY(this.value);

  static String getByValue(num i) {
    return PRIORITY.values.firstWhere((x) => x.value == i).name;
  }

  final int value;
}

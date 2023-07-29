enum TASK_LABEL {
  WORK(0),
  STUDY(1),
  PERSONAL(2);

  const TASK_LABEL(this.value);

  static String getByValue(num i) {
    return TASK_LABEL.values.firstWhere((x) => x.value == i).name;
  }

  final int value;
}

import 'package:hive/hive.dart';

part 'ScoreboardModel.g.dart';

@HiveType(typeId: 1)
class TaskDbModel extends HiveObject {
  @HiveField(0)
  int totalScore = 0;
  @HiveField(1)
  int totalOvers = 0;
  @HiveField(2)
  int currentOverBalls = 0;
  @HiveField(3)
  int currentBatsman = 0;
  @HiveField(4)
  int currentBatsmanRuns = 0;
  @HiveField(5)
  int OBOvers = 0;
  @HiveField(6)
  int PBOvers = 0;
  @HiveField(7)
  int wickets = 0;
  @HiveField(8)
  int totalPlayers = 0;
}

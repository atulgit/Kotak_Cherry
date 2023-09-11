import 'package:hive/hive.dart';
part 'PlayerModel.g.dart';

@HiveType(typeId: 2)
class PlayerModel extends HiveObject {

  @HiveField(0)
  int playerId = -1;

  @HiveField(1)
  String playerName = "";

  @HiveField(2)
  int totalScore = 0;

  @HiveField(3)
  int totalDRS = 0;

  @HiveField(4)
  int playingStatus = 0;

  @HiveField(5)
  int totalWicketsTaken = 0;

  @HiveField(6)
  String initialLevel = "";

  @HiveField(7)
  String currentLevel = "";

  @HiveField(8)
  int overPlayed = 0;

  @HiveField(9)
  int ballsPlayed = 0;

  @HiveField(10)
  String teamId = "";

  PlayerModel(this.playerName, this.playerId, this.teamId);
}

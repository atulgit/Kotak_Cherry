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
  int batsmanPlayingStatus = 0; //0 -> Pending, 1 -> Playing, 2 -> Out(Played)

  @HiveField(5)
  int totalWicketsTaken = 0;

  @HiveField(6)
  String bowlerLevel = ""; //(OB), (PB)

  @HiveField(7)
  String batsmanLevel = ""; //L1,L2,L3

  @HiveField(8)
  int overPlayed = 0;

  @HiveField(9)
  int ballsPlayed = 0;

  @HiveField(10)
  String teamId = "";

  @HiveField(11)
  int points = 0;

  @HiveField(12)
  int playerType = -1; //0 -> Batsman, 1 -> Bowler

  @HiveField(13)
  int bowlerPlayingStatus = -1; //0 -> Not Bowling, 1 -> Bowling, 2 -> Bowling completed

  PlayerModel(this.playerType, this.playerName, this.playerId, this.teamId);
}

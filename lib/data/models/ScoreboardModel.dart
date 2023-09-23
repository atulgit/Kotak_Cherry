import 'package:hive/hive.dart';

part 'ScoreboardModel.g.dart';

@HiveType(typeId: 1)
class ScoreboardModel extends HiveObject {
  @HiveField(0)
  int totalScore = 0;
  @HiveField(1)
  int totalOvers = 0;
  @HiveField(2)
  int currentOverBall = 0;
  @HiveField(3)
  int currentBatsmanId = -1;
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
  @HiveField(9)
  int currentOver = 0;
  @HiveField(10)
  int currentBowlerType = -1;
  @HiveField(11)
  String teamName = "";
  @HiveField(12)
  String teamID = "";
  @HiveField(13)
  String currentOverString = "";
  @HiveField(14)
  int currentBallShotType = 0;
  @HiveField(15)
  int currentBallScore = 0;
  @HiveField(16)
  int isBatting = 0;
  @HiveField(17)
  int isFreeHit = 0;
  @HiveField(18)
  String wicketInfo = "";
  @HiveField(19)
  int isDRS = 0;
  @HiveField(20)
  int BATDRSTaken = 0;
  @HiveField(21)
  int BOWLDRSTaken = 0;
  @HiveField(22)
  int totalBATDRS = 3;
  @HiveField(23)
  int totalBOWLDRS = 3;
  @HiveField(24)
  int DRSTeam = -1; //0 -> BAT Team, 1-> BOWL Team
  @HiveField(25)
  int currentBowlerId = -1;
  @HiveField(26)
  int lastBowlerId = -1;

  ScoreboardModel(this.totalOvers, this.totalPlayers, this.teamID, this.teamName);
}

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kotak_cherry/common/KCUtility.dart';
import 'package:kotak_cherry/data/data_sources/local/DBConstants.dart';
import 'package:kotak_cherry/data/models/PlayerModel.dart';
import 'package:kotak_cherry/data/models/TaskAttachmentDbModel.dart';
import 'package:kotak_cherry/ui/common/Shots.dart';
import 'package:kotak_cherry/ui/common/players/TeamPlayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/KCResult.dart';
import '../../../models/ScoreboardModel.dart';
import '../../../models/TaskDbModel.dart';

class DatabaseService {
  static init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    _registerDataModels();
  }

  static _registerDataModels() {
    if (!Hive.isAdapterRegistered(ScoreboardModelAdapter().typeId)) {
      Hive.registerAdapter(ScoreboardModelAdapter());
    }

    if (!Hive.isAdapterRegistered(PlayerModelAdapter().typeId)) {
      Hive.registerAdapter(PlayerModelAdapter());
    }
  }

  static ScoreboardModel? otherTeamScoreboard;

  static Future<Box<ScoreboardModel>> get _database_tasks => Hive.openBox<ScoreboardModel>(DBContants.TBL_Task);

  static Future<Box<PlayerModel>> get _database_batsman_Team_A => Hive.openBox<PlayerModel>("players_team_batsman_A");

  static Future<Box<PlayerModel>> get _database_batsman_Team_B => Hive.openBox<PlayerModel>("players_team_batsman_B");

  static Future<Box<PlayerModel>> get _database_bowler_Team_A => Hive.openBox<PlayerModel>("players_team_bowler_A");

  static Future<Box<PlayerModel>> get _database_bowler_Team_B => Hive.openBox<PlayerModel>("players_team_bowler_B");

  static Future<Box<TaskAttachmentDbModel>> get _database_attachments => Hive.openBox<TaskAttachmentDbModel>(DBContants.TBL_Attachments);

  static final DatabaseService databaseService = DatabaseService._internal();

  factory DatabaseService() => databaseService;

  DatabaseService._internal();

  List<TaskDbModel> tasks = [
    // TaskDbModel("description", task_id: "100", task_priority: 1, due_date: "2023-09-29", title: "title 1", task_label: 1),
    // TaskDbModel("description", task_id: "101", task_priority: 2, due_date: "2023-09-28", title: "title 2", task_label: 2),
    // TaskDbModel("description", task_id: "101", task_priority: 3, due_date: "2023-06-27", title: "title 3", task_label: 2),
    // TaskDbModel("description", task_id: "101", task_priority: 0, due_date: "2023-09-26", title: "title 0", task_label: 2)
  ];

  Future<void> setOtherTeamScoreboard(ScoreboardModel scoreboardModel) async {
    String otherTeamId = "";
    if (scoreboardModel.teamID == "teamA") {
      otherTeamId = "teamB";
    } else {
      otherTeamId = "teamA";
    }

    otherTeamScoreboard = await DatabaseService.databaseService.getScorecard(otherTeamId);
  }

  Future<Result<TaskDbModel>> fetchTask(String id) async {
    try {
      return Success<TaskDbModel>(tasks.where((element) => element.task_id == id).single);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<List<TaskDbModel>>> fetchSortedAndFilteredTask(int priority, int label, String dueDate, int sortBy, String query) async {
    try {
      final database = await _database_tasks;
      // tasks = database.values.toList();

      return Success<List<TaskDbModel>>(tasks
          .where((element) =>
              (priority == -1 || element.task_priority == priority) &&
              (label == -1 || element.task_label == label) &&
              (query.isEmpty || element.title.toLowerCase().contains(query.toLowerCase())) &&
              (dueDate.isEmpty ||
                  KCUtility.getFormattedDateFromString(dueDate.trim()) == KCUtility.getFormattedDateFromString(element.due_date.trim())))
          .toList());
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<List<TaskDbModel>>> fetchTaskList() async {
    try {
      final database = await _database_tasks;
      //tasks = database.values.toList();

      return Success<List<TaskDbModel>>(tasks);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<TaskDbModel>> setCompletedTask(int taskId) async {
    try {
      // final database = await _database_tasks;
      // var task = database.get(taskId);
      // //task?.is_completed = 1;
      // database.put(taskId, task!);

      return Success<TaskDbModel>(tasks[0]);
    } catch (e) {
      return const Failure();
    }
  }

  Future<Result<TaskDbModel>> saveTask(TaskDbModel taskDbModel) async {
    try {
      final database = await _database_tasks;
      //await database.add(taskDbModel);

      tasks.add(taskDbModel);
      return Success<TaskDbModel>(taskDbModel);
    } catch (e) {
      return const Failure();
    }
  }

  Future<void> deleteScorecard(String teamID) async {
    try {
      final database = await _database_tasks;
      await database.delete(teamID);

      //Clear Batsman, Bowler Tables data for TeamA and TeamB.
      await (await _database_batsman_Team_A).clear();
      await (await _database_batsman_Team_B).clear();
      await (await _database_bowler_Team_A).clear();
      await (await _database_bowler_Team_B).clear();
    } catch (e) {
      String data = "";
    }
  }

  //Start batsman inning for teamId, which is playing the inning. Player Id is just the player number.
  Future<void> startBatsmanInning(String teamId, int playerId) async {
    try {
      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamId)!;
      scoreboardModel.currentBatsmanId = playerId;
      await scoreboardModel.save();

      PlayerModel playerModel;
      if (teamId == "teamA") {
        //Create player inning for TeamA
        final database = await _database_batsman_Team_A;
        playerModel = database.get(playerId)!;
        playerModel.batsmanPlayingStatus = 1; //Playing
        database.put(playerId, playerModel);
      } else if (teamId == "teamB") {
        //Create player inning for TeamB
        final database = await _database_batsman_Team_B;
        playerModel = database.get(playerId)!;
        playerModel.batsmanPlayingStatus = 1; //Playing
        database.put(playerId, playerModel);
      }
    } catch (e) {
      String data = "";
    }
  }

  //Player Id is just the player number.
  //Player level will be L1 for now.
  //Create Batsman
  // Future<void> createBatsman(
  //     String teamId, String playerName, int playerId, String batsmanLevel, String bowlerLevel, Box<PlayerModel> database) async {
  //   try {
  //     PlayerModel playerModel = PlayerModel(0, playerName, playerId, teamId, batsmanLevel, bowlerLevel);
  //     database.put(playerId, playerModel);
  //
  //     // if (teamId == "teamA") {
  //     //   //Create player inning for TeamA
  //     //   // final database = await _database_batsman_Team_A;
  //     //   playerModel = PlayerModel(0, playerName, playerId, teamId, batsmanLevel, bowlerLevel);
  //     //   // playerModel.playingStatus = 1; //Playing
  //     //   database.put(playerId, playerModel);
  //     // } else if (teamId == "teamB") {
  //     //   //Create player inning for TeamB
  //     //   // final database = await _database_batsman_Team_B;
  //     //   playerModel = PlayerModel(0, playerName, playerId, teamId, batsmanLevel, bowlerLevel);
  //     //   // playerModel.playingStatus = 1; //Playing
  //     //   database.put(playerId, playerModel);
  //     // }
  //   } catch (e) {
  //     String data = "";
  //   }
  // }

  //Player Id is just the player number.
  //Player level will be L1 for now.
  //Create Bowler
  // Future<void> createBowler(String teamId, String playerName, int playerId, String bowlerLevel, Box<PlayerModel> database) async {
  //   try {
  //     PlayerModel playerModel;
  //     if (teamId == "teamA") {
  //       //Create player inning for TeamA
  //       // final database = await _database_batsman_Team_A;
  //       playerModel = PlayerModel(1, playerName, playerId, teamId);
  //       playerModel.bowlerLevel = bowlerLevel;
  //       // playerModel.playingStatus = 1; //Playing
  //       database.put(playerId, playerModel);
  //     } else if (teamId == "teamB") {
  //       //Create player inning for TeamB
  //       // final database = await _database_batsman_Team_B;
  //       playerModel = PlayerModel(1, playerName, playerId, teamId);
  //       playerModel.bowlerLevel = bowlerLevel;
  //       // playerModel.playingStatus = 1; //Playing
  //       database.put(playerId, playerModel);
  //     }
  //   } catch (e) {
  //     String data = "";
  //   }
  // }

  // Future<void> setBatsmanScore(Shot shotObj, String teamId, int playerId) async {
  //   try {} catch (e) {
  //     String data = "";
  //   }
  // }

  Future<void> setBatsmanAndBowlerDelievery(Shot shotObj, String batsmanTeamId, int batsmanId, int bowlerId) async {
    try {
      String bowlerTeamId = (batsmanTeamId == "teamA") ? "teamB" : "teamA";

      Box<PlayerModel> databaseBatsman = (batsmanTeamId == "teamA") ? await _database_batsman_Team_A : await _database_batsman_Team_B;
      Box<PlayerModel> databaseBowler = (bowlerTeamId == "teamA") ? await _database_bowler_Team_A : await _database_bowler_Team_B;

      PlayerModel? batsmanModel = databaseBatsman.get(batsmanId.toInt());
      PlayerModel? bowlerModel = databaseBowler.get(bowlerId.toInt());

      int batsmanPoints = 0;
      int bowlerPoints = 0;

      switch (shotObj.shot_type) {
        case SHOT_TYPE.four:
          batsmanPoints += 4;
          bowlerPoints -= 4;
          batsmanModel!.totalScore += int.parse(shotObj.value);
          bowlerModel!.totalScore += int.parse(shotObj.value);
          break;

        case SHOT_TYPE.six:
          batsmanPoints += 6;
          bowlerPoints -= 6;
          batsmanModel!.totalScore += int.parse(shotObj.value);
          bowlerModel!.totalScore += int.parse(shotObj.value);
          break;

        case SHOT_TYPE.singles:
          batsmanPoints += int.parse(shotObj.value);
          bowlerPoints -= int.parse(shotObj.value);
          batsmanModel!.totalScore += int.parse(shotObj.value);
          bowlerModel!.totalScore += int.parse(shotObj.value);
          break;

        case SHOT_TYPE.wb:
          bowlerPoints -= 1;
          batsmanModel!.totalScore += 1 + int.parse(shotObj.value);
          bowlerModel!.totalScore += 1 + int.parse(shotObj.value);
          break;

        case SHOT_TYPE.nb:
          bowlerPoints -= 2;
          batsmanModel!.totalScore += 1 + int.parse(shotObj.value);
          bowlerModel!.totalScore += 1 + int.parse(shotObj.value);
          break;

        case SHOT_TYPE.db:
          bowlerPoints += 1;
          batsmanPoints -= 1;
          break;

        case SHOT_TYPE.wicket:
          batsmanPoints -= 10;
          bowlerPoints += 10;
          batsmanModel!.batsmanPlayingStatus = 2; //Mark batsman as Out.
          break;

        //Pending delivery, if Third Umpire, will be converted to DB or Wicket as per decision by batsman.
        case SHOT_TYPE.tuWicket:
          break;

        default:
          break;
      }

      batsmanModel!.points += batsmanPoints;
      bowlerModel!.points += bowlerPoints;

      //If ball is not No-Ball & Wide-Ball & DRS, Update played overs and balls played by batsman.
      if (shotObj.shot_type != SHOT_TYPE.nb && shotObj.shot_type != SHOT_TYPE.wb && shotObj.shot_type != SHOT_TYPE.tuWicket) {
        if (batsmanModel!.ballsPlayed <= 4) {
          //Current Over, running over.
          batsmanModel!.ballsPlayed += 1; //Update current over ball.
        } else {
          //Over complete
          batsmanModel!.overPlayed += 1; //update completed over.
          batsmanModel!.ballsPlayed = 0; //reset over ball to zero.
        }
      }

      //If ball is not No-Ball & Wide-Ball & DRS, Update played overs and balls played by bowler.
      if (shotObj.shot_type != SHOT_TYPE.nb && shotObj.shot_type != SHOT_TYPE.wb && shotObj.shot_type != SHOT_TYPE.tuWicket) {
        if (bowlerModel!.ballsPlayed <= 4) {
          //Current Over, running over.
          bowlerModel!.ballsPlayed += 1; //Update current over ball.
        } else {
          //Over complete, update total overs played & reset balls played.
          bowlerModel!.overPlayed += 1; //update completed over.
          bowlerModel!.ballsPlayed = 0; //reset over ball to zero.
        }
      }

      await batsmanModel!.save();
      await bowlerModel!.save();
    } catch (e) {
      String data = "";
    }
  }

  Future<ScoreboardModel?> createScorecard(String teamID, String teamName, int overs) async {
    try {
      int players = TeamPlayers.TeamAPlayers.length;
      // if (overs == 10) {
      //   players = 5;
      // } else {
      //   players = 10;
      // }

      ScoreboardModel scoreboardModelA = ScoreboardModel(overs, players, teamID, teamName);
      final database = await _database_tasks;
      await database.put(teamID, scoreboardModelA);
      final Box<PlayerModel> batsmanDatabase = (teamID == "teamA") ? await _database_batsman_Team_A : await _database_batsman_Team_B;
      final Box<PlayerModel> bowlerDatabase = (teamID == "teamA") ? await _database_bowler_Team_A : await _database_bowler_Team_B;

      //TeamA is considered as AUS, and TeamB is considered as IND for now.
      var playersList = teamID == "teamA" ? TeamPlayers.TeamBPlayers : TeamPlayers.TeamAPlayers;

      //Create batsman score card for selected team.
      for (int i = 0; i <= 9; i++) {
        PlayerModel playerModel =
            PlayerModel(0, playersList[i].playerName, playersList[i].playerId, teamID, playersList[i].batsmanLevel, playersList[i].bowlerLevel);
        batsmanDatabase.put(playersList[i].playerId, playerModel);
      }

      //Create bowler score card for selected team.
      for (int i = 0; i <= 9; i++) {
        PlayerModel playerModel =
            PlayerModel(1, playersList[i].playerName, playersList[i].playerId, teamID, playersList[i].batsmanLevel, playersList[i].bowlerLevel);
        bowlerDatabase.put(playersList[i].playerId, playerModel);
      }

      return scoreboardModelA;
    } catch (e) {
      return null;
    }
  }

  Future<PlayerModel?> getBatsman(String batsmanTeamId, int playerId) async {
    try {
      Box<PlayerModel> database = (batsmanTeamId == "teamA") ? await _database_batsman_Team_A : await _database_batsman_Team_B;
      return database.get(playerId);
    } catch (e) {
      return null;
    }
  }

  Future<PlayerModel?> getBowler(String batsmanTeamId, int playerId) async {
    try {
      String bowlderTeamId = (batsmanTeamId == "teamA") ? "teamB" : "teamA";
      Box<PlayerModel> database = (bowlderTeamId == "teamA") ? await _database_bowler_Team_A : await _database_bowler_Team_B;
      return database.get(playerId);
    } catch (e) {
      return null;
    }
  }

  Future<List<PlayerModel>?> getBattingScoreboard(String teamId) async {
    try {
      Box<PlayerModel> database = (teamId == "teamA") ? await _database_batsman_Team_A : await _database_batsman_Team_B;
      return database.values.toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<PlayerModel>?> getBowlingScoreboard(String teamId) async {
    try {
     // String bowlingTeamId = (playingTeamId == "teamA") ? "teamB" : "teamA";
      Box<PlayerModel> database = (teamId == "teamA") ? await _database_bowler_Team_A : await _database_bowler_Team_B;
      return database.values.toList();
    } catch (e) {
      return null;
    }
  }

  Future<ScoreboardModel?> getScorecard(String teamAID) async {
    try {
      final database = await _database_tasks;
      return database.get(teamAID);
    } catch (e) {
      return null;
    }
  }

  //Initialize new over. with selected bowler type and bowler Id. Reset over string.
  //Also do this after checking if the current over ball is already set to zero.
  Future<ScoreboardModel?> initOver(int bowlerType, int bowlerId, String teamId) async {
    try {

      String teamIdForScorecard = (teamId == "teamA") ? "teamB" : "teamA";

      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamIdForScorecard)!;

      if (scoreboardModel.currentOverBall == 0) {
        scoreboardModel.currentBowlerType = bowlerType;
        scoreboardModel.currentBowlerId = bowlerId;
        scoreboardModel.currentOverString = "";
      }

      PlayerModel playerModel;
      if (teamId == "teamA") {
        //Create player inning for TeamA
        final database = await _database_bowler_Team_A;
        playerModel = database.get(bowlerId)!;
        playerModel.bowlerPlayingStatus = 1; //Playing
        database.put(bowlerId, playerModel);
      } else if (teamId == "teamB") {
        //Create player inning for TeamB
        final database = await _database_bowler_Team_B;
        playerModel = database.get(bowlerId)!;
        playerModel.bowlerPlayingStatus = 1; //Playing
        database.put(bowlerId, playerModel);
      }

      await scoreboardModel.save();
      return scoreboardModel;
    } catch (e) {
      return null;
    }
  }

  Future<ScoreboardModel?> startInning(String teamId) async {
    try {
      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamId)!;
      scoreboardModel.isBatting = 1;

      //await DatabaseService.databaseService.startBatsmanInning(teamId, 0, "L1");

      await scoreboardModel.save();
      return scoreboardModel;
    } catch (e) {
      return null;
    }
  }

  Future<ScoreboardModel?> setIsDRS(int isDRS, int DRSTeam, String teamId) async {
    try {
      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamId)!;
      scoreboardModel.isDRS = isDRS;
      scoreboardModel.DRSTeam = DRSTeam;

      await scoreboardModel.save();
      return scoreboardModel;
    } catch (e) {
      return null;
    }
  }

  Future<ScoreboardModel?> clearDRS(String teamId) async {
    try {
      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamId)!;
      scoreboardModel.isDRS = 0;
      scoreboardModel.DRSTeam = -1;

      await scoreboardModel.save();
      return scoreboardModel;
    } catch (e) {
      return null;
    }
  }

  Future<ScoreboardModel?> setDRS(String teamId, int playerId) async {
    try {
      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamId)!;

      //If DRS ball, only then take DRS
      if (scoreboardModel.isDRS == 1) {
        if (scoreboardModel.DRSTeam == 0 && scoreboardModel.BATDRSTaken < scoreboardModel.totalBATDRS) {
          //if BAT Team takes DRS & no. of DRS remaining for BAT team
          scoreboardModel.BATDRSTaken += 1;
          await setPlayerDRS(playerId, teamId);
        } else if (scoreboardModel.DRSTeam == 1 && scoreboardModel.BOWLDRSTaken < scoreboardModel.totalBOWLDRS) {
          //If bowl team takes DRS  & no. of DRS remaining for Bowl team
          scoreboardModel.BOWLDRSTaken += 1;
        }
      }
      scoreboardModel.isDRS = 0;
      scoreboardModel.DRSTeam = -1;

      await scoreboardModel.save();
      return scoreboardModel;
    } catch (e) {
      return null;
    }
  }

  Future<void> setPlayerDRS(int playerId, String teamId) async {
    try {
      Box<PlayerModel> database = (teamId == "teamA") ? await _database_batsman_Team_A : await _database_batsman_Team_B;
      PlayerModel? playerModel = database.get(playerId.toInt());
      playerModel!.totalDRS += 1;

      await playerModel.save();
    } catch (e) {}
  }

  //bowler = 0 --> OB, 1 --> PB
  Future<ScoreboardModel?> saveBall(Shot shot, String teamId) async {
    try {
      final database = await _database_tasks;
      ScoreboardModel scoreboardModel = database.get(teamId)!;
      // scoreboardModel.isFreeHit = 0; //initialize free hit update to zero.

      //Get last ball shot type. (to check for free hit.)
      SHOT_TYPE lastShotType = SHOT_TYPE.getByValue(scoreboardModel.currentBallShotType);
      if (lastShotType == SHOT_TYPE.nb) {
        scoreboardModel.isFreeHit = 1;
      } else {
        scoreboardModel.isFreeHit = 0;
      }

      scoreboardModel.currentBallShotType = shot.shot_type.value;

      //Set batsman delivery, bowl by bowl (Scores, wicket status, DRS, over played).
      await setBatsmanAndBowlerDelievery(shot, teamId, scoreboardModel.currentBatsmanId, scoreboardModel.currentBowlerId);

      switch (shot.shot_type) {
        case SHOT_TYPE.six:
          scoreboardModel.totalScore += int.parse(shot.value);
          scoreboardModel.currentOverString += " ${shot.value}";
          scoreboardModel.currentBallScore = int.parse(shot.value);
          break;

        case SHOT_TYPE.four:
          scoreboardModel.totalScore += int.parse(shot.value);
          scoreboardModel.currentOverString += " ${shot.value}";
          scoreboardModel.currentBallScore = int.parse(shot.value);
          break;

        case SHOT_TYPE.singles:
          scoreboardModel.totalScore += int.parse(shot.value);
          scoreboardModel.currentOverString += " ${shot.value}";
          scoreboardModel.currentBallScore = int.parse(shot.value);
          break;

        case SHOT_TYPE.db:
          scoreboardModel.currentOverString += " ${shot.value}";
          scoreboardModel.currentBallScore = 0;
          break;

        case SHOT_TYPE.nb:
          var noBallScore = (1 + int.parse(shot.value));
          scoreboardModel.totalScore += noBallScore;
          scoreboardModel.currentOverString += "${shot.value} 1nb";
          scoreboardModel.currentBallScore = noBallScore;
          break;

        case SHOT_TYPE.wb:
          var wideBallScore = (1 + int.parse(shot.value));
          scoreboardModel.totalScore += wideBallScore;
          scoreboardModel.currentOverString += " wb";
          scoreboardModel.currentBallScore = wideBallScore;
          break;

        case SHOT_TYPE.wicket:
          //Mark out If this is not free hit OR it is run out on free hit.
          if (scoreboardModel.isFreeHit == 0 || (scoreboardModel.isFreeHit == 1 && shot.value == "R")) {
            scoreboardModel.wickets += 1;
            scoreboardModel.currentOverString += " W";
            scoreboardModel.wicketInfo = shot.value;
            scoreboardModel.currentBallScore = 0;
            scoreboardModel.currentBatsmanId = -1; //Remove current batsman Id when batsman is out.
            if (scoreboardModel.wickets < scoreboardModel.totalPlayers) {
              //Change batsman.
              //scoreboardModel.currentBatsmanId += 1;
              //await startBatsmanInning(teamId, scoreboardModel.currentBatsmanId, "L1");
            }
          } else {
            //Last ball was No-Ball
            //FREE-HIT
          }
          break;

        //If this is Third-Umpire delivery, set DRS status
        case SHOT_TYPE.tuWicket:
          scoreboardModel.isDRS = 1; //It is DRS delivery
          scoreboardModel.wicketInfo = shot.value; //Original Decision
          if (shot.value == "O") {
            scoreboardModel.DRSTeam = 0; //BAT Team DRS
          } else if (shot.value == "NO") {
            scoreboardModel.DRSTeam = 1; //BOWL Team DRS
          }
          break;

        default:
          break;
      }

      //If ball is not No-Ball & Wide-Ball & DRS
      if (shot.shot_type != SHOT_TYPE.nb && shot.shot_type != SHOT_TYPE.wb && shot.shot_type != SHOT_TYPE.tuWicket) {
        if (scoreboardModel.currentOverBall <= 4) {
          //Current Over, running over.
          scoreboardModel.currentOverBall += 1; //Update current over ball.
        } else {
          //Over complete
          scoreboardModel.currentOver += 1; //update completed over.
          scoreboardModel.currentOverBall = 0; //reset over ball to zero.

          if (scoreboardModel.currentBowlerType == 0) {
            //update OB completed overs
            scoreboardModel.OBOvers += 1;
          } else if (scoreboardModel.currentBowlerType == 1) {
            //Update PB completed overs.
            scoreboardModel.PBOvers += 1;
          }

          scoreboardModel.currentBowlerType = -1; //Reset current bowler type, when over is completed.
          scoreboardModel.lastBowlerId = scoreboardModel.currentBowlerId;
          scoreboardModel.currentBowlerId = -1;
        }

        //match completed, overs completed or wickets completed.
        if (scoreboardModel.currentOver == scoreboardModel.totalOvers ||
            scoreboardModel.wickets == scoreboardModel.totalPlayers ||
            (otherTeamScoreboard != null && otherTeamScoreboard!.isBatting == 2 && (scoreboardModel.totalScore > otherTeamScoreboard!.totalScore))) {
          scoreboardModel.isBatting = 2; //Update playing status to completed.
        }
      }

      database.put(teamId, scoreboardModel);

      if (database.length > 0) {
        return scoreboardModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Result> saveAttachments(List<TaskAttachmentDbModel> attachments) async {
    try {
      final database = await _database_attachments;
      attachments.map((e) async {
        await database.add(e);
      });

      return const Success<void>(1);
    } catch (e) {
      return const Failure();
    }
  }
}

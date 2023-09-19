import '../../../data/models/PlayerModel.dart';

mixin TeamPlayers {
  static final List<PlayerModel> TeamAPlayers = [
    PlayerModel(-1, "Virat Kohli", 0, "teamA", "L1", "NA"),
    PlayerModel(-1, "Rohit Sharma", 1, "teamA", "L1", "NA"),
    PlayerModel(-1, "Sachin Tendulkar", 2, "teamA", "L1", "NA"),
    PlayerModel(-1, "Virender Sehwag", 3, "teamA", "L2", "NA"),
    PlayerModel(-1, "Gautam Gambhir", 4, "teamA", "L2", "NA"),
    PlayerModel(-1, "Hardik Pandeya", 5, "teamA", "L2", "PB"),
    PlayerModel(-1, "Mohammad Shami", 6, "teamA", "L3", "PB"),
    PlayerModel(-1, "Jaspreet Bumrah", 7, "teamA", "L3", "PB"),
    PlayerModel(-1, "Bhuvneshwar Kumar", 8, "teamA", "L3", "OB"),
    PlayerModel(-1, "Harbhajan Singh", 9, "teamA", "L3", "OB")
  ];

  static final List<PlayerModel> TeamBPlayers = [
    PlayerModel(-1, "Jason Behrendorff", 0, "teamB", "L1", "NA"),
    PlayerModel(-1, "Adam Gilchrist", 1, "teamB", "L1", "NA"),
    PlayerModel(-1, "Adam Voges", 2, "teamB", "L1", "NA"),
    PlayerModel(-1, "George Bailey", 3, "teamB", "L2", "NA"),
    PlayerModel(-1, "Ricky Ponting", 4, "teamB", "L2", "NA"),
    PlayerModel(-1, "Brad Haddin", 5, "teamB", "L2", "PB"),
    PlayerModel(-1, "Shane Watson", 6, "teamB", "L3", "PB"),
    PlayerModel(-1, "Brett Lee", 7, "teamB", "L3", "PB"),
    PlayerModel(-1, "Michael Clarke", 8, "teamB", "L3", "OB"),
    PlayerModel(-1, "Cameron White", 9, "teamB", "L3", "OB")
  ];
}

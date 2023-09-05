// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ScoreboardModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreboardModelAdapter extends TypeAdapter<ScoreboardModel> {
  @override
  final int typeId = 1;

  @override
  ScoreboardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreboardModel(
      fields[1] as int,
      fields[8] as int,
      fields[12] as String,
      fields[11] as String,
    )
      ..totalScore = fields[0] as int
      ..currentOverBall = fields[2] as int
      ..currentBatsman = fields[3] as int
      ..currentBatsmanRuns = fields[4] as int
      ..OBOvers = fields[5] as int
      ..PBOvers = fields[6] as int
      ..wickets = fields[7] as int
      ..currentOver = fields[9] as int
      ..currentBowlerType = fields[10] as int
      ..currentOverString = fields[13] as String
      ..currentBallShotType = fields[14] as int
      ..currentBallScore = fields[15] as int
      ..isPlaying = fields[16] as int
      ..isFreeHit = fields[17] as int
      ..wicketType = fields[18] as String;
  }

  @override
  void write(BinaryWriter writer, ScoreboardModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.totalScore)
      ..writeByte(1)
      ..write(obj.totalOvers)
      ..writeByte(2)
      ..write(obj.currentOverBall)
      ..writeByte(3)
      ..write(obj.currentBatsman)
      ..writeByte(4)
      ..write(obj.currentBatsmanRuns)
      ..writeByte(5)
      ..write(obj.OBOvers)
      ..writeByte(6)
      ..write(obj.PBOvers)
      ..writeByte(7)
      ..write(obj.wickets)
      ..writeByte(8)
      ..write(obj.totalPlayers)
      ..writeByte(9)
      ..write(obj.currentOver)
      ..writeByte(10)
      ..write(obj.currentBowlerType)
      ..writeByte(11)
      ..write(obj.teamName)
      ..writeByte(12)
      ..write(obj.teamID)
      ..writeByte(13)
      ..write(obj.currentOverString)
      ..writeByte(14)
      ..write(obj.currentBallShotType)
      ..writeByte(15)
      ..write(obj.currentBallScore)
      ..writeByte(16)
      ..write(obj.isPlaying)
      ..writeByte(17)
      ..write(obj.isFreeHit)
      ..writeByte(18)
      ..write(obj.wicketType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreboardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

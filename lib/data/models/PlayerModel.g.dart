// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlayerModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerModelAdapter extends TypeAdapter<PlayerModel> {
  @override
  final int typeId = 2;

  @override
  PlayerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerModel(
      fields[1] as String,
      fields[0] as int,
      fields[10] as String,
    )
      ..totalScore = fields[2] as int
      ..totalDRS = fields[3] as int
      ..playingStatus = fields[4] as int
      ..totalWicketsTaken = fields[5] as int
      ..initialLevel = fields[6] as String
      ..currentLevel = fields[7] as String
      ..overPlayed = fields[8] as int
      ..ballsPlayed = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, PlayerModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.playerName)
      ..writeByte(2)
      ..write(obj.totalScore)
      ..writeByte(3)
      ..write(obj.totalDRS)
      ..writeByte(4)
      ..write(obj.playingStatus)
      ..writeByte(5)
      ..write(obj.totalWicketsTaken)
      ..writeByte(6)
      ..write(obj.initialLevel)
      ..writeByte(7)
      ..write(obj.currentLevel)
      ..writeByte(8)
      ..write(obj.overPlayed)
      ..writeByte(9)
      ..write(obj.ballsPlayed)
      ..writeByte(10)
      ..write(obj.teamId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

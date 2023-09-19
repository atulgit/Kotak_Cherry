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
      fields[12] as int,
      fields[1] as String,
      fields[0] as int,
      fields[10] as String,
      fields[7] as String,
      fields[6] as String,
    )
      ..totalScore = fields[2] as int
      ..totalDRS = fields[3] as int
      ..batsmanPlayingStatus = fields[4] as int
      ..totalWicketsTaken = fields[5] as int
      ..overPlayed = fields[8] as int
      ..ballsPlayed = fields[9] as int
      ..points = fields[11] as int
      ..bowlerPlayingStatus = fields[13] as int;
  }

  @override
  void write(BinaryWriter writer, PlayerModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.playerName)
      ..writeByte(2)
      ..write(obj.totalScore)
      ..writeByte(3)
      ..write(obj.totalDRS)
      ..writeByte(4)
      ..write(obj.batsmanPlayingStatus)
      ..writeByte(5)
      ..write(obj.totalWicketsTaken)
      ..writeByte(6)
      ..write(obj.bowlerLevel)
      ..writeByte(7)
      ..write(obj.batsmanLevel)
      ..writeByte(8)
      ..write(obj.overPlayed)
      ..writeByte(9)
      ..write(obj.ballsPlayed)
      ..writeByte(10)
      ..write(obj.teamId)
      ..writeByte(11)
      ..write(obj.points)
      ..writeByte(12)
      ..write(obj.playerType)
      ..writeByte(13)
      ..write(obj.bowlerPlayingStatus);
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

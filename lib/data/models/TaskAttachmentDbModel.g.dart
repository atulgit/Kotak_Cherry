// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskAttachmentDbModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAttachmentDbModelAdapter extends TypeAdapter<TaskAttachmentDbModel> {
  @override
  final int typeId = 1;

  @override
  TaskAttachmentDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskAttachmentDbModel(
      fields[1] as int,
      fields[2] as String,
      fields[0] as int,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskAttachmentDbModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.attachmentId)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAttachmentDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskDbModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskDbModelAdapter extends TypeAdapter<TaskDbModel> {
  @override
  final int typeId = 1;

  @override
  TaskDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskDbModel(
      fields[4] as String,
      task_id: fields[0] as String,
      task_priority: fields[1] as int,
      due_date: fields[5] as String,
      title: fields[3] as String,
      task_label: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskDbModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.task_id)
      ..writeByte(1)
      ..write(obj.task_priority)
      ..writeByte(2)
      ..write(obj.task_label)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.due_date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locks.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocksAdapter extends TypeAdapter<Locks> {
  @override
  final int typeId = 2;

  @override
  Locks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Locks(
      value: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Locks obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_value.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeValueAdapter extends TypeAdapter<ThemeValue> {
  @override
  final int typeId = 1;

  @override
  ThemeValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeValue(
      id: fields[0] as String,
      value: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeValue obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordStorageAdapter extends TypeAdapter<PasswordStorage> {
  @override
  final int typeId = 0;

  @override
  PasswordStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordStorage(
      id: fields[0] as String,
      title: fields[1] as String,
      username: fields[2] as String,
      password: fields[3] as String,
      important: fields[4] as bool,
      click: fields[5] as int,
      createAt: fields[6] as String,
      updatedAt: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordStorage obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.important)
      ..writeByte(5)
      ..write(obj.click)
      ..writeByte(6)
      ..write(obj.createAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

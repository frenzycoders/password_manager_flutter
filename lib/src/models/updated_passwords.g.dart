// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_passwords.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpdatedPasswordsAdapter extends TypeAdapter<UpdatedPasswords> {
  @override
  final int typeId = 5;

  @override
  UpdatedPasswords read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdatedPasswords(
      id: fields[0] as String,
      title: fields[1] as String,
      username: fields[2] as String,
      password: fields[3] as String,
      important: fields[4] as bool,
      click: fields[5] as int,
      createAt: fields[6] as String,
      updatedAt: fields[7] as String,
      cloud_id: fields[8] as String,
      uploaded: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UpdatedPasswords obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.cloud_id)
      ..writeByte(9)
      ..write(obj.uploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdatedPasswordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

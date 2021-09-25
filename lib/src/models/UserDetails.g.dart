// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 8;

  @override
  UserDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetails(
      id: fields[0] as String,
      email: fields[1] as String,
      key: fields[2] as String,
      eKey: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.key)
      ..writeByte(3)
      ..write(obj.eKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

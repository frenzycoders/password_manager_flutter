// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_passwords.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeletedPasswordsAdapter extends TypeAdapter<DeletedPasswords> {
  @override
  final int typeId = 3;

  @override
  DeletedPasswords read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeletedPasswords(
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeletedPasswords obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeletedPasswordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

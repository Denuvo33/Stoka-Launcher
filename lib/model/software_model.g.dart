// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'software_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoftwareModelAdapter extends TypeAdapter<SoftwareModel> {
  @override
  final int typeId = 1;

  @override
  SoftwareModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoftwareModel(
      path: fields[0] as String?,
      name: fields[1] as String?,
      iconPath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SoftwareModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoftwareModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

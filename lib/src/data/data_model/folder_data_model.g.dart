// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderDataModelAdapter extends TypeAdapter<FolderDataModel> {
  @override
  final int typeId = 0;

  @override
  FolderDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FolderDataModel(
      id: fields[1] as int,
      name: fields[0] as String,
      background: fields[2] as int,
      icon: fields[3] as int,
      dateOfLastChange: fields[4] as String,
      iconSize: fields[6] as double,
      iconColor: fields[5] as int,
      iconFamily: fields[7] as String?,
      iconPackage: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FolderDataModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.background)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.dateOfLastChange)
      ..writeByte(5)
      ..write(obj.iconColor)
      ..writeByte(6)
      ..write(obj.iconSize)
      ..writeByte(7)
      ..write(obj.iconFamily)
      ..writeByte(8)
      ..write(obj.iconPackage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

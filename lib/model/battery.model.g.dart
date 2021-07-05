// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BatteryAdapter extends TypeAdapter<Battery> {
  @override
  final int typeId = 1;

  @override
  Battery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Battery(
      id: fields[0] as String?,
      userID: fields[1] as String?,
      tag: fields[2] as String?,
      brand: fields[3] as String?,
      capacity: fields[4] as int?,
      cells: fields[5] as int?,
      volts: fields[6] as double?,
      percent: fields[7] as double?,
      status: fields[8] as String?,
      lastLogUpdate: fields[9] as int?,
      cycle: fields[10] as int?,
      updatedAt: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Battery obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.tag)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.capacity)
      ..writeByte(5)
      ..write(obj.cells)
      ..writeByte(6)
      ..write(obj.volts)
      ..writeByte(7)
      ..write(obj.percent)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.lastLogUpdate)
      ..writeByte(10)
      ..write(obj.cycle)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatteryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

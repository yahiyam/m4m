// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songdb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongsAdapter extends TypeAdapter<Songs> {
  @override
  final int typeId = 0;

  @override
  Songs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Songs(
      songPath: fields[0] as String,
      songTitle: fields[1] as String,
      songArtist: fields[2] as String,
      id: fields[3] as int,
      album: fields[5] as String,
      flag: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Songs obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.songPath)
      ..writeByte(1)
      ..write(obj.songTitle)
      ..writeByte(2)
      ..write(obj.songArtist)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.flag)
      ..writeByte(5)
      ..write(obj.album);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'package:hive_flutter/hive_flutter.dart';
part 'songdb.g.dart';

@HiveType(typeId: 0)
class Songs {
  @HiveField(0)
  String songPath;

  @HiveField(1)
  String songTitle;

  @HiveField(2)
  String songArtist;

  @HiveField(3)
  int id;

  @HiveField(4)
  int flag;

  @HiveField(5)
  String album;
  
  Songs({
    required this.songPath,
    required this.songTitle,
    required this.songArtist,
    required this.id,
    required this.album,
    this.flag = 0,
  });
}

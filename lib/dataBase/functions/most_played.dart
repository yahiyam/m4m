import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/songdb.dart';
import 'db_functions.dart';

class MostPlayedSongs {
  static final Box<List> playlistBox = getPlaylistBox();
  static final Box<Songs> songBox = getSongBox();
  static addSongtoMostPlayed(
      {required BuildContext context, required String id}) async {
    final List<Songs> allSongs = songBox.values.toList().cast<Songs>();
    final List<Songs> mostPlayedSongList =
        playlistBox.get('MostPlayed')!.toList().cast<Songs>();
    final Songs mostPlayedSong =
        allSongs.firstWhere((song) => song.songPath.contains(id));
    if (mostPlayedSongList.length > 15) {
      mostPlayedSongList.removeLast();
    }

    if (mostPlayedSong.flag >= 5) {
      if (mostPlayedSongList
          .where((song) => song.songPath == mostPlayedSong.songPath)
          .isEmpty) {
        mostPlayedSongList.add(mostPlayedSong);
        await playlistBox.put('MostPlayed', mostPlayedSongList);
      } else {
        mostPlayedSongList
            .removeWhere((song) => song.songPath == mostPlayedSong.songPath);
        mostPlayedSongList.add(mostPlayedSong);
        await playlistBox.put('MostPlayed', mostPlayedSongList);
      }
    }
  }
}

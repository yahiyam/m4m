import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/songdb.dart';
import 'db_functions.dart';
import 'most_played.dart';

class RecentSongs {
  static final Box<List> playlistBox = getPlaylistBox();
  static final Box<Songs> songBox = getSongBox();

  static addSongtoRecent(
      {required BuildContext context, required String id}) async {
    final List<Songs> allSongs = songBox.values.toList().cast<Songs>();
    final List<Songs> recentSongList =
        playlistBox.get('RecentSongs')!.toList().cast<Songs>();
    final Songs recentSong =
        allSongs.firstWhere((song) => song.songPath.contains(id));
    int count = recentSong.flag;
    recentSong.flag = count + 1;

    MostPlayedSongs.addSongtoMostPlayed(context: context, id: id);

    if (recentSongList.length > 10) {
      recentSongList.removeLast();
    }

    if (recentSongList
        .where((song) => song.songPath == recentSong.songPath)
        .isEmpty) {
      recentSongList.add(recentSong);
      await playlistBox.put('RecentSongs', recentSongList);
    } else {
      recentSongList
          .removeWhere((song) => song.songPath == recentSong.songPath);
      recentSongList.add(recentSong);
      await playlistBox.put('RecentSongs', recentSongList);
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'db_functions.dart';
import '../models/songdb.dart';

class SongsToPlaylist {
  static final Box<List> playlistSongBox = getPlaylistBox();
  static final Box<Songs> songBox = getSongBox();

  static addSongToPlaylist({
    required BuildContext context,
    required String id,
    required String playlistName,
  }) async {
    final List<Songs> songsList = songBox.values.toList().cast();
    final List<Songs> playlistNameList =
        playlistSongBox.get(playlistName)!.toList().cast<Songs>();
    final Songs playlistMusicRef =
        songsList.firstWhere((song) => song.songPath.contains(id));
    String message;
    message = playlistMusicRef.songTitle.length <= 35
        ? "${playlistMusicRef.songTitle}...\nRemoved from $playlistName "
        : "${playlistMusicRef.songTitle.substring(0, 35)}...\nRemoved from $playlistName ";
    if (playlistNameList
        .where((songs) => songs.songPath == playlistMusicRef.songPath)
        .isEmpty) {
      playlistNameList.add(playlistMusicRef);
      await playlistSongBox.put(playlistName, playlistNameList);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: message,
        ),
        dismissType: DismissType.onSwipe,
      );
    } else {
      playlistNameList
          .removeWhere((songs) => songs.songPath == playlistMusicRef.songPath);
      await playlistSongBox.put(playlistName, playlistNameList);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          backgroundColor: Colors.grey,
          message: message,
        ),
        dismissType: DismissType.onSwipe,
      );
    }
  }

  static IconData isInPlaylist({
    required String id,
    required String playlistName,
  }) {
    final List<Songs> storageSongs = songBox.values.toList().cast();
    List<Songs> playlistNameList =
        playlistSongBox.get(playlistName)!.toList().cast();
    Songs liked = storageSongs.firstWhere((song) => song.songPath.contains(id));
    return playlistNameList
            .where((song) => song.songPath == liked.songPath)
            .isEmpty
        ? Icons.add
        : Icons.remove;
  }
}

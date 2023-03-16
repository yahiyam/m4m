// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'db_functions.dart';
import '../models/songdb.dart';

class PlaylistSong {
  static final Box<List> likedSongBox = getPlaylistBox();
  static final Box<Songs> songBox = getSongBox();

  static addSongToLiked(
      {required BuildContext context, required String id}) async {
    final List<Songs> songsList = songBox.values.toList().cast<Songs>();
    final List<Songs> likedList =
        likedSongBox.get('LikedSongs')!.toList().cast<Songs>();
    final Songs likedMusicRef =
        songsList.firstWhere((song) => song.songPath.contains(id));
    String message;
    message = likedMusicRef.songTitle.length <= 35
        ? "${likedMusicRef.songTitle}\nadded to favorites"
        : "${likedMusicRef.songTitle.substring(0, 35)}...\nadded to favorites";
    if (likedList
        .where((songs) => songs.songPath == likedMusicRef.songPath)
        .isEmpty) {
      likedList.add(likedMusicRef);
      await likedSongBox.put('LikedSongs', likedList);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: message),
        dismissType: DismissType.onSwipe,
      );
    } else {
      likedList
          .removeWhere((songs) => songs.songPath == likedMusicRef.songPath);
      await likedSongBox.put('LikedSongs', likedList);
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

  static IconData isLiked({required String id}) {
    final List<Songs> storageSongs = songBox.values.toList().cast();
    List<Songs> likedList = likedSongBox.get('LikedSongs')!.toList().cast();
    Songs liked = storageSongs.firstWhere((song) => song.songPath.contains(id));
    return likedList.where((song) => song.songPath == liked.songPath).isEmpty
        ? Icons.favorite_border
        : Icons.favorite;
  }
}

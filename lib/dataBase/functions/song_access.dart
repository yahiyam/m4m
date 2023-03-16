import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/songdb.dart';
import 'db_functions.dart';

class SongAccess {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final List<SongModel> sortedSongs = [];
  final Box<Songs> songBox = getSongBox();
  final Box<List> playlistbox = getPlaylistBox();
  final List<Songs> likedSongs = [];
  final List<Songs> recentSongs = [];
  final List<Songs> mostPlayed = [];

  Future<void> accessSongs() async {
    final accessedSongs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for (var song in accessedSongs) {
      sortedSongs.add(song);
    }
    for (var audio in sortedSongs) {
      final song = Songs(
        songPath: audio.uri!,
        songTitle: audio.title,
        songArtist: audio.artist!,
        id: audio.id,
        album: audio.album.toString(),
      );
      await songBox.put(audio.id, song);
    }
    await accessTheKeysForLikedSongs();
    await accessTheKeysForRecentSongs();
    await accessTheKeysForMostPlayedSongs();
  }

  Future<void> accessTheKeysForLikedSongs() async {
    if (!playlistbox.keys.contains('LikedSongs')) {
      await playlistbox.put('LikedSongs', likedSongs);
    }
  }

  Future<void> accessTheKeysForRecentSongs() async {
    if (!playlistbox.keys.contains('RecentSongs')) {
      await playlistbox.put('RecentSongs', recentSongs);
    }
  }

  Future<void> accessTheKeysForMostPlayedSongs() async {
    if (!playlistbox.keys.contains('MostPlayed')) {
      await playlistbox.put('MostPlayed', mostPlayed);
    }
  }
}

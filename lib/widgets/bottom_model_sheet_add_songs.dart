import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../dataBase/functions/db_functions.dart';
import '../dataBase/models/songdb.dart';
import '../dataBase/functions/function_for_adding_song_to_playlist.dart';

class BottomModelSheet {
  static Box<List> playlistBox = getPlaylistBox();
  static Box<Songs> songBox = getSongBox();

  static showBottomModelSheetAddSongTOPlaylsit(
      {required String playlistName, required BuildContext context}) async {
    List<Songs> audioList = [];
    final List<int> keys = songBox.keys.toList().cast<int>();
    for (var key in keys) {
      audioList.add(songBox.get(key)!);
    }
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return ListView.builder(
            itemCount: audioList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(index.toString()),
                ),
                title: Text(
                  audioList[index].songTitle,
                  maxLines: 1,
                ),
                trailing: IconButton(
                  onPressed: () {
                    SongsToPlaylist.addSongToPlaylist(
                      context: context,
                      id: audioList[index].songPath,
                      playlistName: playlistName,
                    );
                    setState(
                      () {
                        SongsToPlaylist.isInPlaylist(
                          id: audioList[index].songPath,
                          playlistName: playlistName,
                        );
                      },
                    );
                  },
                  icon: Icon(
                    SongsToPlaylist.isInPlaylist(
                      id: audioList[index].songPath,
                      playlistName: playlistName,
                    ),
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}

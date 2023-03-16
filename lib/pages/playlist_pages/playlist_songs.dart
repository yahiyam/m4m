import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/widgets/audio_view.dart';

import '../../dataBase/functions/db_functions.dart';
import '../../dataBase/models/songdb.dart';
import '../../widgets/bottom_model_sheet_add_songs.dart';

class PlaylistSongs extends StatefulWidget {
  final String playlistName;
  final List<Songs> songList;
  const PlaylistSongs({
    Key? key,
    required this.playlistName,
    required this.songList,
  }) : super(key: key);

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  bool isGrid = true;
  Box<List> playlistBox = getPlaylistBox();
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  late final String playlistName;
  @override
  void initState() {
    super.initState();
    playlistName = widget.playlistName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
              icon: Icon(isGrid ? Icons.list : Icons.grid_view))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: playlistBox.listenable(),
          builder: (context, value, child) {
            List<Songs> musicList =
                playlistBox.get(playlistName)!.reversed.toList().cast<Songs>();
            if (musicList.isEmpty) {
              return Center(
                child: Text(
                  'Add some songs to $playlistName ',
                ),
              );
            } else {
              return AudioTileView(
                audiosList: musicList,
                audioPlayer: audioPlayer,
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BottomModelSheet.showBottomModelSheetAddSongTOPlaylsit(
            playlistName: playlistName,
            context: context,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

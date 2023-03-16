import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../dataBase/functions/db_functions.dart';
import '../../dataBase/functions/function_for_adding_song_to_playlist.dart';
import '../../dataBase/functions/playlist_functions.dart';

class AddToPlaylist extends StatefulWidget {
  const AddToPlaylist({
    Key? key,
    required this.index,
    required this.audioPlayer,
    required this.songList,
  }) : super(key: key);
  final String index;
  final List<Audio> songList;
  final AssetsAudioPlayer audioPlayer;
  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  Box<List> playlistBox = getPlaylistBox();
  List _foundedPlaylist = [];

  @override
  void initState() {
    _foundedPlaylist = List.from(playlistBox.keys.toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('${playlistBox.length - 3} playlist'),
                const Text(
                  'Add to Playlist',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  PlaylistFunctions.playlistCreateAlertBox(context: context);
                });
              },
              child: const Text('New Playlist'),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: playlistBox.listenable(),
                  builder: (context, value, child) {
                    _foundedPlaylist
                        .removeWhere((element) => element == 'MostPlayed');
                    _foundedPlaylist
                        .removeWhere((element) => element == 'LikedSongs');
                    _foundedPlaylist
                        .removeWhere((element) => element == 'RecentSongs');
                    return playlistBox.length < 4
                        ? const Center(
                            child: Text('No Playlist Found Please Create One'))
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GridView.builder(
                              itemCount: _foundedPlaylist.length,
                              itemBuilder: (context, index) {
                                final String playlistName =
                                    _foundedPlaylist[index];
                                return ListTile(
                                  leading: const Icon(Icons.folder),
                                  title: Text(playlistName),
                                  trailing: IconButton(
                                    onPressed: () {
                                      SongsToPlaylist.addSongToPlaylist(
                                        context: context,
                                        id: widget.index,
                                        playlistName: playlistName,
                                      );
                                      setState(
                                        () {
                                          SongsToPlaylist.isInPlaylist(
                                            id: widget.index,
                                            playlistName: playlistName,
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      SongsToPlaylist.isInPlaylist(
                                        id: widget.index,
                                        playlistName: playlistName,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisExtent: 50,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

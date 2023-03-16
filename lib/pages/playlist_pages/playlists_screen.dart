import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/pages/playlist_pages/playlist_songs.dart';

import '../../dataBase/functions/db_functions.dart';
import '../../dataBase/models/songdb.dart';
import '../../dataBase/functions/playlist_functions.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  Box<List> playlistBox = getPlaylistBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playlist"),
      ),
      body: ValueListenableBuilder(
        valueListenable: playlistBox.listenable(),
        builder: (context, value, child) {
          List keys = playlistBox.keys.toList();
          keys.removeWhere((element) => element == 'LikedSongs');
          keys.removeWhere((element) => element == 'RecentSongs');
          keys.removeWhere((element) => element == 'MostPlayed');
          return keys.isEmpty
              ? const Center(
                  child: Text('Save your music collections in playlist'),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                        bottom: kBottomNavigationBarHeight + 40),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final String playlistName = keys[index];
                      final List<Songs> playlistSongList =
                          playlistBox.get(playlistName)!.toList().cast<Songs>();
                      return Stack(
                        alignment: Alignment.topRight,
                        fit: StackFit.loose,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlaylistSongs(
                                  playlistName: playlistName,
                                  songList: playlistSongList,
                                ),
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      playlistName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      maxLines: 2,
                                    ),
                                    Text('${playlistSongList.length} Songs'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            surfaceTintColor: Colors.deepPurple,
                            elevation: 1,
                            constraints: const BoxConstraints(maxWidth: 133),
                            icon: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      PlaylistFunctions.playlistDeleteFunction(
                                        context: context,
                                        playlistName: playlistName,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: const Text("Delete"),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      PlaylistFunctions.playlistEditFunction(
                                        context: context,
                                        songs: playlistSongList,
                                        playlistName: playlistName,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                    ),
                                    label: const Text("Edit"),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          PlaylistFunctions.playlistCreateAlertBox(context: context);
        },
        label: Text('add a playlist'.toUpperCase()),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

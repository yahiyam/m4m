import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:m4m/dataBase/functions/liked_song.dart';
import 'package:m4m/dataBase/functions/recently_played.dart';
import 'package:m4m/widgets/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../dataBase/models/songdb.dart';
import '../pages/playlist_pages/add_to_playlist.dart';

class AudioTileView extends StatefulWidget {
  const AudioTileView({
    super.key,
    required this.audiosList,
    required this.audioPlayer,
  });
  final List<Songs> audiosList;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<AudioTileView> createState() => _AudioTileViewState();
}

class _AudioTileViewState extends State<AudioTileView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + 30,
      ),
      itemCount: widget.audiosList.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 15),
          onTap: () async {
            RecentSongs.addSongtoRecent(
              context: context,
              id: widget.audiosList[index].songPath,
            );
            showMiniPlayer(
              context: context,
              index: index,
              songList: widget.audiosList,
              audioPlayer: widget.audioPlayer,
            );
          },
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 10),
            child: Text(widget.audiosList[index].songTitle),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.audiosList[index].album,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          leading: QueryArtworkWidget(
            artworkBorder: BorderRadius.circular(5),
            id: widget.audiosList[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const CircleAvatar(
              radius: 25,
              child: Icon(Icons.music_note),
            ),
          ),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  PlaylistSong.addSongToLiked(
                    context: context,
                    id: widget.audiosList[index].songPath,
                  );
                  setState(() {
                    PlaylistSong.isLiked(id: widget.audiosList[index].songPath);
                  });
                },
                icon: Icon(
                  PlaylistSong.isLiked(id: widget.audiosList[index].songPath),
                  color: Colors.pink,
                ),
              ),
              PopupMenuButton(
                constraints: BoxConstraints.tight(const Size(175, 65)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddToPlaylist(
                                index: widget.audiosList[index].songPath,
                                audioPlayer: widget.audioPlayer,
                                songList: widget.audiosList.cast<Audio>(),
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.playlist_add),
                      label: const Text('Add to playlist'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class AudioGridView extends StatefulWidget {
  const AudioGridView({
    super.key,
    required this.audiosList,
    required this.audioPlayer,
  });
  final List<Songs> audiosList;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<AudioGridView> createState() => _AudioGridViewState();
}

class _AudioGridViewState extends State<AudioGridView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 30),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: widget.audiosList.length,
        itemBuilder: (context, index) {
          return GridTile(
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    PlaylistSong.addSongToLiked(
                      context: context,
                      id: widget.audiosList[index].songPath,
                    );
                    setState(() {
                      PlaylistSong.isLiked(
                          id: widget.audiosList[index].songPath);
                    });
                  },
                  icon: Icon(
                    PlaylistSong.isLiked(id: widget.audiosList[index].songPath),
                    color: Colors.pink,
                  ),
                ),
                PopupMenuButton(
                  color: Colors.white,
                  constraints: BoxConstraints.tight(const Size(175, 65)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddToPlaylist(
                                      index: widget.audiosList[index].songPath,
                                      audioPlayer: widget.audioPlayer,
                                      songList: widget.audiosList.cast<Audio>(),
                                    );
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.playlist_add),
                            label: const Text('Add to playlist'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            footer: Text(
              widget.audiosList[index].songTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            child: GestureDetector(
              onTap: () async {
                RecentSongs.addSongtoRecent(
                  context: context,
                  id: widget.audiosList[index].songPath,
                );
                showMiniPlayer(
                  context: context,
                  index: index,
                  songList: widget.audiosList,
                  audioPlayer: widget.audioPlayer,
                );
              },
              child: QueryArtworkWidget(
                artworkBorder: BorderRadius.circular(5),
                id: widget.audiosList[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

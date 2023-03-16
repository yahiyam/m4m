import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/widgets/audio_view.dart';

import '../../dataBase/functions/db_functions.dart';
import '../../dataBase/models/songdb.dart';

// ignore: must_be_immutable
class FavoriteSongsScreen extends StatefulWidget {
  bool isGridMode;

  FavoriteSongsScreen({
    super.key,
    required this.isGridMode,
  });
  @override
  State<FavoriteSongsScreen> createState() => _FavoriteSongsScreenState();
}

class _FavoriteSongsScreenState extends State<FavoriteSongsScreen> {
  final audioPlayer = AssetsAudioPlayer.withId('0');
  Box<List> playlistBox = getPlaylistBox();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 10.0),
          //       child: ElevatedButton.icon(
          //         onPressed: () {
          //           setState(() {
          //             isGrid = !isGrid;
          //           });
          //         },
          //         label: Text(isGrid ? 'List View' : 'Grid view'),
          //         icon: Icon(isGrid ? Icons.list : Icons.grid_view),
          //       ),
          //     ),
          //   ],
          // ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: playlistBox.listenable(),
              builder: (context, songs, _) {
                List<Songs> favoriteList = playlistBox
                    .get('LikedSongs')!
                    .reversed
                    .toList()
                    .cast<Songs>();
                if (favoriteList.isEmpty) {
                  return Center(
                    child: Text(
                      "No Favorite Songs Found :(\n${playlistBox.get('LikedSongs')!.toList().length} favorite songs",
                    ),
                  );
                } else {
                  if (widget.isGridMode) {
                    return AudioGridView(
                      audiosList: favoriteList,
                      audioPlayer: audioPlayer,
                    );
                  } else {
                    return AudioTileView(
                      audiosList: favoriteList,
                      audioPlayer: audioPlayer,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

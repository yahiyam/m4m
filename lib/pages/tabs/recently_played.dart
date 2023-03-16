import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/widgets/audio_view.dart';

import '../../dataBase/functions/db_functions.dart';
import '../../dataBase/models/songdb.dart';

// ignore: must_be_immutable
class RecentlyPlayed extends StatefulWidget {
  bool isGridMode;
  RecentlyPlayed({
    super.key,
    required this.isGridMode,
  });

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  final Box<List> playlistBox = getPlaylistBox();

  final Box<Songs> songBox = getSongBox();
  // bool isGrid = false;
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Visibility(
              visible: playlistBox.get('RecentSongs')!.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            playlistBox.get('RecentSongs')!.clear();
                          });
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(color: Colors.red),
                        )),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10.0),
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {
                    //       setState(() {
                    //         isGrid = !isGrid;
                    //       });
                    //     },
                    //     label: Text(isGrid ? 'List view' : 'Grid view'),
                    //     icon: const Icon(Icons.grid_view),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: playlistBox.listenable(),
                builder: (context, value, _) {
                  List<Songs> musicList = playlistBox
                      .get('RecentSongs')!
                      .reversed
                      .toList()
                      .cast<Songs>();
                  if (musicList.isEmpty) {
                    return const Center(
                      child: Text("Play some music and check me"),
                    );
                  } else {
                    if (widget.isGridMode) {
                      return AudioGridView(
                        audiosList: musicList,
                        audioPlayer: audioPlayer,
                      );
                    } else {
                      return AudioTileView(
                        audiosList: musicList,
                        audioPlayer: audioPlayer,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

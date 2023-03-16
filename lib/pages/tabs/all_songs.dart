import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:m4m/widgets/audio_view.dart';
// import 'package:m4m/widgets/toggle_grid.dart';

import '../../dataBase/models/songdb.dart';

// ignore: must_be_immutable
class AllSongs extends StatefulWidget {
  AllSongs({
    super.key,
    required this.isGridMode,
    required this.foundSongs,
  });
  final List<Songs> foundSongs;
  bool isGridMode;

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final audioPlayer = AssetsAudioPlayer.withId('0');
  // bool isGrid = false;
  Box<Songs> songBox = Hive.box<Songs>('Songs');
  List<Songs> audioList = [];
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
          //             // isGrid = !isGrid;
          //           });
          //         },
          //         label: Text('Grid view'),
          //         icon: toggleGridIcon(viewType),
          //       ),
          //     ),
          //   ],
          // ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: songBox.listenable(),
              builder: (context, songs, _) {
                if (songs.isNotEmpty) {
                  if (widget.isGridMode) {
                    return AudioGridView(
                      audiosList: widget.foundSongs,
                      audioPlayer: audioPlayer,
                    );
                  } else {
                    return AudioTileView(
                      audiosList: widget.foundSongs,
                      audioPlayer: audioPlayer,
                    );
                  }
                } else {
                  return const Center(
                    child: Text("No songs Found"),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

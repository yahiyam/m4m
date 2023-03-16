import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/widgets/audio_view.dart';

import '../dataBase/functions/db_functions.dart';
import '../dataBase/models/songdb.dart';

class MostPlayed extends StatefulWidget {
  const MostPlayed({super.key});

  @override
  State<MostPlayed> createState() => _MostPlayedState();
}

class _MostPlayedState extends State<MostPlayed> {
  bool isGrid = false;

  final Box<List> playlistBox = getPlaylistBox();

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Most Played'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: Icon(
              isGrid ? Icons.list : Icons.grid_view_rounded,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ValueListenableBuilder(
            valueListenable: playlistBox.listenable(),
            builder: (context, value, _) {
              List<Songs> musicList = playlistBox
                  .get('MostPlayed')!
                  .reversed
                  .toList()
                  .cast<Songs>();
              if (musicList.isEmpty) {
                return const Center(
                  child: Text(
                    'play what you like and find the most played songs here',
                  ),
                );
              } else {
                if (isGrid) {
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
            }),
      ),
    );
  }
}

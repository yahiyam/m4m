import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:m4m/dataBase/models/songdb.dart';
import 'package:m4m/widgets/audio_view.dart';

class SearchSongs extends SearchDelegate {
  final List<Songs> audioList;
  final AssetsAudioPlayer audioPlayer;
  SearchSongs({
    required this.audioList,
    required this.audioPlayer,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Songs> results = [];
    if (query.isEmpty) {
      results = audioList;
    } else {
      results = audioList
          .where((element) => element.songTitle
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    return Scaffold(
      body: results.isEmpty
          ? const Center(
              child: Text(
                'No Search Result !',
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: AudioTileView(
                audiosList: results,
                audioPlayer: audioPlayer,
              ),
            ),
    );
  }
}

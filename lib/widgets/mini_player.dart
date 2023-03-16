import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';

import 'package:marquee/marquee.dart';

import '../dataBase/models/songdb.dart';
import '../pages/song_play_screen.dart';

class MiniMusicPlayer extends StatefulWidget {
  const MiniMusicPlayer({
    Key? key,
    required this.audioPlayer,
    required this.index,
    required this.songList,
  }) : super(key: key);

  final List<Songs> songList;
  final int index;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<MiniMusicPlayer> createState() => _MiniMusicPlayerState();
}

class _MiniMusicPlayerState extends State<MiniMusicPlayer> {
  List<Audio> songAudio = [];
  bool playbuttonMini = true;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  convertMusic() {
    for (var song in widget.songList) {
      songAudio.add(
        Audio.file(
          song.songPath,
          metas: Metas(
            title: song.songTitle,
            id: song.id.toString(),
            artist: song.songArtist,
          ),
        ),
      );
    }
  }

  Future<void> openAudioPlayer() async {
    await widget.audioPlayer.open(
      Playlist(audios: songAudio, startIndex: widget.index),
      autoStart: true,
      showNotification: true,
      playInBackground: PlayInBackground.enabled,
    );
  }

  @override
  void initState() {
    convertMusic();
    openAudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioPlayer.builderCurrent(
      builder: (context, playing) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SongScreen(
                        index: widget.index,
                        audioPlayer: widget.audioPlayer,
                        songList: songAudio,
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Marquee(
                        startAfter: const Duration(seconds: 2),
                        text: widget.audioPlayer.getCurrentAudioTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.audioPlayer.previous();
                            playMini();
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            widget.audioPlayer.playOrPause();
                            setState(() {
                              playbuttonMini ? pausedmini() : playMini();
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD933C3)),
                            child: PlayerBuilder.isPlaying(
                              player: widget.audioPlayer,
                              builder: (context, isPlaying) {
                                return isPlaying
                                    ? const Icon(
                                        Icons.pause_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      );
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.audioPlayer.next();
                            playMini();
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  pausedmini() {
    setState(() {
      playbuttonMini = false;
    });
  }

  playMini() {
    setState(() {
      playbuttonMini = true;
    });
  }
}

showMiniPlayer({
  required BuildContext context,
  required int index,
  required List<Songs> songList,
  required AssetsAudioPlayer audioPlayer,
}) {
  return showBottomSheet(
    backgroundColor: const Color(0xFF3B1F50),
    context: context,
    builder: (context) {
      return MiniMusicPlayer(
        audioPlayer: audioPlayer,
        index: index,
        songList: songList,
      );
    },
  );
}

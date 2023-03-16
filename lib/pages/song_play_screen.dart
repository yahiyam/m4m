import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:m4m/pages/playlist_pages/add_to_playlist.dart';
import 'package:marquee/marquee.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../dataBase/functions/liked_song.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({
    Key? key,
    required this.index,
    required this.audioPlayer,
    required this.songList,
  }) : super(key: key);

  final int index;
  final List<Audio> songList;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  bool playorpauseIcon = true;
  bool isLooping = false;
  bool isSound = true;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B1F50),
      body: widget.audioPlayer.builderCurrent(
        builder: (context, playing) {
          final musicAuido =
              find(widget.songList, playing.audio.assetAudioPath);
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 30,
                        color: Colors.white24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 297,
                      width: 297,
                      child: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(10),
                        id: int.parse(musicAuido.metas.id!),
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const CircleAvatar(
                          child: Icon(
                            Icons.music_note,
                            size: 160,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Marquee(
                      blankSpace: 70,
                      startAfter: const Duration(seconds: 5),
                      text: widget.audioPlayer.getCurrentAudioTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.audioPlayer.getCurrentAudioArtist,
                      style: const TextStyle(
                          color: Color(0xFFC87DFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                widget.audioPlayer.builderRealtimePlayingInfos(
                    builder: (context, info) {
                  final duration = info.current!.audio.duration;
                  final progress = info.currentPosition;
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ProgressBar(
                      progress: progress,
                      total: duration,
                      progressBarColor: const Color(0xFFD933C3),
                      thumbColor: const Color(0xFFD933C3),
                      thumbGlowColor: const Color.fromARGB(103, 217, 51, 195),
                      baseBarColor: const Color.fromARGB(87, 217, 51, 195),
                      barHeight: 8,
                      timeLabelTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 13),
                      onSeek: ((value) {
                        widget.audioPlayer.seek(value);
                      }),
                    ),
                  );
                }),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        isLooping ? loopingOff() : loopingOn();
                      },
                      icon: isLooping
                          ? const Icon(
                              Icons.repeat_rounded,
                              size: 30,
                              color: Color(0xFFD933C3),
                            )
                          : const Icon(
                              Icons.repeat_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.audioPlayer.previous();
                        },
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                    GestureDetector(
                      onTap: () {
                        widget.audioPlayer.playOrPause();
                        setState(() {
                          playorpauseIcon ? pauseIcons() : playIcon();
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFD933C3)),
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
                        onPressed: () async {
                          await widget.audioPlayer.next();
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shuffle_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            PlaylistSong.addSongToLiked(
                                context: context, id: musicAuido.metas.id!);
                            PlaylistSong.isLiked(id: musicAuido.metas.id!);
                          });
                        },
                        icon:
                            Icon(PlaylistSong.isLiked(id: musicAuido.metas.id!),
                                color: const Color(
                                  0xFFD933C3,
                                ),
                                size: 30)),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => AddToPlaylist(
                                index: musicAuido.metas.id!,
                                audioPlayer: widget.audioPlayer,
                                songList: widget.songList,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.playlist_add_rounded,
                            color: Colors.white, size: 30)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  pauseIcons() {
    setState(() {
      playorpauseIcon = false;
    });
  }

  playIcon() {
    setState(() {
      playorpauseIcon = true;
    });
  }

  loopingOn() {
    widget.audioPlayer.play();
    widget.audioPlayer.setLoopMode(LoopMode.single);
    playIcon();
    setState(() {
      isLooping = true;
    });
  }

  loopingOff() {
    widget.audioPlayer.setLoopMode(LoopMode.none);
    setState(() {
      isLooping = false;
    });
  }
}

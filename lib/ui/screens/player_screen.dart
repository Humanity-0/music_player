import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/audio_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/lyric_view.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  void _playPause(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context, listen: false);
    if (audio.isPlaying) {
      audio.pause();
    } else {
      if (audio.currentSong != null) {
        audio.playSong(audio.currentSong!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audio, child) {
        final currentSong = audio.currentSong;
        return Scaffold(
          appBar: AppBar(
            title: Text(currentSong?.title ?? "No Song Playing"),
          ),
          body: currentSong == null
              ? const Center(child: Text("No song playing"))
              : Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Album art
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Uri.parse(currentSong.albumArtPath).isScheme("file")
                                    ? FileImage(File(Uri.parse(currentSong.albumArtPath).toFilePath()))
                                    : const AssetImage('assets/default_art.png') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(currentSong.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("${currentSong.artist} - ${currentSong.album}"),
                          const SizedBox(height: 20),
                          // Position and Duration
                          StreamBuilder<Duration?>(
                            stream: audio.positionStream,
                            builder: (context, snapshot) {
                              final pos = snapshot.data ?? Duration.zero;
                              return StreamBuilder<Duration?>(
                                stream: audio.durationStream,
                                builder: (context, snapshotDur) {
                                  final dur = snapshotDur.data ?? Duration.zero;
                                  return Slider(
                                    value: pos.inSeconds.toDouble(),
                                    max: dur.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      audio.seek(Duration(seconds: value.toInt()));
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          Expanded(
                            child: LyricView(lyrics: currentSong.lyrics),
                          ),
                        ],
                      ),
                    ),
                    PlayerControls(
                      isPlaying: audio.isPlaying,
                      onPlayPause: () => _playPause(context),
                      onNext: () {},
                      onPrevious: () {},
                      onShuffle: () => audio.toggleShuffle(),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

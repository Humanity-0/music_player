// lib/ui/screens/player_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/library_provider.dart';
import '../../data/models/song.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final libraryProvider = Provider.of<LibraryProvider>(context);
    
    return StreamBuilder<PlaybackState>(
      stream: audioProvider.playbackStateStream,
      builder: (context, snapshot) {
        final playbackState = snapshot.data;
        final isPlaying = playbackState?.playing ?? false;
        final processingState = playbackState?.processingState ?? AudioProcessingState.idle;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<MediaItem?>(
              stream: audioProvider.currentMediaItemStream,
              builder: (context, snapshot) {
                final mediaItem = snapshot.data;
                if (mediaItem == null) {
                  return const Text('No song playing');
                }
                return Column(
                  children: [
                    Text(
                      mediaItem.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mediaItem.artist ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    audioProvider.skipToPrevious();
                  },
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  onPressed: () {
                    if (isPlaying) {
                      audioProvider.pause();
                    } else {
                      audioProvider.play(); // Implement play without song selection
                    }
                  },
                ),
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    audioProvider.skipToNext();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add a slider for playback position if needed
          ],
        );
      },
    );
  }
}

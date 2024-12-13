// lib/providers/audio_provider.dart

import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import '../data/models/song.dart';

class AudioProvider extends ChangeNotifier {
  final AudioHandler _audioHandler;

  AudioProvider({required AudioHandler audioHandler}) : _audioHandler = audioHandler;

  Stream<PlaybackState> get playbackStateStream => _audioHandler.playbackState;

  Stream<MediaItem?> get currentMediaItemStream => _audioHandler.currentMediaItem;

  Future<void> playSong(Song song) async {
    // Convert your Song model to MediaItem
    final mediaItem = MediaItem(
      id: song.albumArtPath, // Use a unique identifier, such as the song's URI
      album: song.album,
      title: song.title,
      artist: song.artist,
      // Add more metadata if needed
    );

    // Clear the queue and add the selected song
    await _audioHandler.queue.clear();
    await _audioHandler.addQueueItem(mediaItem);
    await _audioHandler.play();
  }

  Future<void> play() async {
    // Resume playback
    await _audioHandler.play();
  }

  Future<void> pause() => _audioHandler.pause();

  Future<void> stop() => _audioHandler.stop();

  Future<void> skipToNext() => _audioHandler.skipToNext();

  Future<void> skipToPrevious() => _audioHandler.skipToPrevious();

  Future<void> seek(Duration position) => _audioHandler.seek(position);
}

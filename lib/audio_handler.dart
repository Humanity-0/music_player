// lib/audio_handler.dart

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MyAudioHandler() {
    // Broadcast playback state changes.
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    
    // Listen to changes in the player's sequence and update the queue accordingly.
    _player.currentIndexStream.listen((index) {
      if (index != null && queue.value.length > index) {
        mediaItem.add(queue.value[index]);
      }
    });
    
    // Handle when the player completes playing the last song.
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
      }
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final newQueue = List<MediaItem>.from(queue.value)..add(mediaItem);
    queue.add(newQueue);
    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: newQueue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ),
    );
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final newQueue = queue.value..remove(mediaItem);
    queue.add(newQueue);
    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: newQueue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ),
    );
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      updateTime: DateTime.now(),
    );
  }

  // Expose the player's current song as a stream.
  Stream<MediaItem?> get currentMediaItem => mediaItem.stream;
}

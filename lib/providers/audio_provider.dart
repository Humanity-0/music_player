import 'package:flutter/foundation.dart';
import '../data/models/song.dart';
import '../services/audio_player_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  
  Song? currentSong;
  bool isShuffling = false;

  Stream<Duration?> get positionStream => _audioService.positionStream;
  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<PlayerState> get playerStateStream => _audioService.playerStateStream;

  Future<void> playSong(Song song) async {
    currentSong = song;
    await _audioService.playSong(song);
    notifyListeners();
  }

  void pause() async {
    await _audioService.pause();
    notifyListeners();
  }

  void stop() async {
    await _audioService.stop();
    currentSong = null;
    notifyListeners();
  }

  void toggleShuffle() async {
    isShuffling = !isShuffling;
    await _audioService.setShuffleMode(isShuffling);
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioService.seek(position);
  }

  bool get isPlaying => _audioService.isPlaying;
}

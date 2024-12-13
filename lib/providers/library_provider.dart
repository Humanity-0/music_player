import 'package:flutter/foundation.dart';
import '../data/models/song.dart';
import '../data/repositories/song_repository.dart';

class LibraryProvider extends ChangeNotifier {
  final SongRepository _songRepo = SongRepository();
  List<Song> allSongs = [];
  List<Song> favorites = [];
  List<Song> recentlyPlayed = [];
  List<Song> recentlyAdded = [];
  List<Song> mostPlayed = [];

  Future<void> loadLibrary() async {
    allSongs = await _songRepo.getAllSongs();
    favorites = await _songRepo.getFavorites();
    recentlyPlayed = await _songRepo.getRecentlyPlayed();
    recentlyAdded = await _songRepo.getRecentlyAdded();
    mostPlayed = await _songRepo.getMostPlayed();
    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    await _songRepo.toggleFavorite(song.id!, !song.isFavorite);
    await loadLibrary();
  }

  Future<void> addOrUpdateSong(Song song) async {
    if (song.id == null) {
      await _songRepo.insertSong(song);
    } else {
      await _songRepo.updateSong(song);
    }
    await loadLibrary();
  }

  Future<void> deleteSong(Song song) async {
    if (song.id != null) {
      await _songRepo.deleteSong(song.id!);
      await loadLibrary();
    }
  }
}

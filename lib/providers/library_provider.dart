// lib/providers/library_provider.dart

import 'package:flutter/foundation.dart';
import '../data/models/song.dart';
import '../data/repositories/song_repository.dart';
// Since we're not using on_audio_query, media querying is assumed to be handled elsewhere.

class LibraryProvider extends ChangeNotifier {
  final SongRepository _songRepo = SongRepository();
  List<Song> allSongs = [];
  List<Song> favorites = [];
  List<Song> recentlyPlayed = [];
  List<Song> recentlyAdded = [];
  List<Song> mostPlayed = [];

  /// Initializes the library by loading existing songs from the database
  Future<void> loadLibrary() async {
    allSongs = await _songRepo.getAllSongs();
    favorites = await _songRepo.getFavorites();
    recentlyPlayed = await _songRepo.getRecentlyPlayed();
    recentlyAdded = await _songRepo.getRecentlyAdded();
    mostPlayed = await _songRepo.getMostPlayed();
    notifyListeners();
  }

  /// Queries and loads songs into the database
  /// Note: Implement your own media querying logic here or use another plugin
  Future<void> queryAndLoadSongs() async {
    // Placeholder for media querying logic
    // Replace this with actual implementation to retrieve songs from the device

    // Example: Adding a predefined list of songs
    List<Song> fetchedSongs = [
      Song(
        title: 'Song One',
        artist: 'Artist A',
        album: 'Album X',
        albumArtPath: '', // Provide valid URIs or paths
        lyrics: '',
      ),
      Song(
        title: 'Song Two',
        artist: 'Artist B',
        album: 'Album Y',
        albumArtPath: '',
        lyrics: '',
      ),
      // Add more songs as needed
    ];

    for (var song in fetchedSongs) {
      bool exists = allSongs.any((s) => s.title == song.title && s.artist == song.artist);
      if (!exists) {
        await _songRepo.insertSong(song);
      }
    }

    await loadLibrary();
  }

  /// Toggles the favorite status of a song
  Future<void> toggleFavorite(Song song) async {
    await _songRepo.toggleFavorite(song.id!, !song.isFavorite);
    await loadLibrary();
  }

  /// Adds or updates a song in the database
  Future<void> addOrUpdateSong(Song song) async {
    if (song.id == null) {
      await _songRepo.insertSong(song);
    } else {
      await _songRepo.updateSong(song);
    }
    await loadLibrary();
  }

  /// Deletes a song from the database
  Future<void> deleteSong(Song song) async {
    if (song.id != null) {
      await _songRepo.deleteSong(song.id!);
      await loadLibrary();
    }
  }
}

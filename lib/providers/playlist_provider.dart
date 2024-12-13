import 'package:flutter/foundation.dart';
import '../data/models/playlist.dart';
import '../data/models/song.dart';
import '../data/repositories/playlist_repository.dart';

class PlaylistProvider extends ChangeNotifier {
  final PlaylistRepository _playlistRepo = PlaylistRepository();
  List<Playlist> playlists = [];
  Map<int, List<Song>> playlistSongs = {};

  Future<void> loadPlaylists() async {
    playlists = await _playlistRepo.getAllPlaylists();
    for (var p in playlists) {
      playlistSongs[p.id!] = await _playlistRepo.getSongsInPlaylist(p.id!);
    }
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    await _playlistRepo.createPlaylist(Playlist(name: name));
    await loadPlaylists();
  }

  Future<void> addSongToPlaylist(int playlistId, Song song) async {
    await _playlistRepo.addSongToPlaylist(playlistId, song.id!);
    await loadPlaylists();
  }

  Future<void> removeSongFromPlaylist(int playlistId, Song song) async {
    await _playlistRepo.removeSongFromPlaylist(playlistId, song.id!);
    await loadPlaylists();
  }

  Future<void> deletePlaylist(int playlistId) async {
    await _playlistRepo.deletePlaylist(playlistId);
    await loadPlaylists();
  }
}

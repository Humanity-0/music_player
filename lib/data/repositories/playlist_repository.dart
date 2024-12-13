import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class PlaylistRepository {
  final dbProvider = AppDatabase.instance;

  Future<int> createPlaylist(Playlist playlist) async {
    final db = await dbProvider.database;
    return await db.insert('playlists', playlist.toMap());
  }

  Future<List<Playlist>> getAllPlaylists() async {
    final db = await dbProvider.database;
    final result = await db.query('playlists', orderBy: 'name ASC');
    return result.map((e) => Playlist.fromMap(e)).toList();
  }

  Future<int> updatePlaylist(Playlist playlist) async {
    final db = await dbProvider.database;
    return db.update('playlists', playlist.toMap(), where: 'id = ?', whereArgs: [playlist.id]);
  }

  Future<int> deletePlaylist(int id) async {
    final db = await dbProvider.database;
    return db.delete('playlists', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    final db = await dbProvider.database;
    await db.insert('playlist_songs', {'playlistId': playlistId, 'songId': songId},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await dbProvider.database;
    await db.delete('playlist_songs',
        where: 'playlistId = ? AND songId = ?', whereArgs: [playlistId, songId]);
  }

  Future<List<Song>> getSongsInPlaylist(int playlistId) async {
    final db = await dbProvider.database;
    final result = await db.rawQuery('''
      SELECT s.* FROM songs s
      JOIN playlist_songs ps ON s.id = ps.songId
      WHERE ps.playlistId = ?
      ORDER BY s.title ASC
    ''', [playlistId]);
    return result.map((e) => Song.fromMap(e)).toList();
  }
}

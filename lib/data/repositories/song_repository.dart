import 'package:sqflite/sqflite.dart';
import '../database.dart';
import '../models/song.dart';

class SongRepository {
  final dbProvider = AppDatabase.instance;

  Future<int> insertSong(Song song) async {
    final db = await dbProvider.database;
    return await db.insert('songs', song.toMap());
  }

  Future<List<Song>> getAllSongs() async {
    final db = await dbProvider.database;
    final result = await db.query('songs', orderBy: 'title ASC');
    return result.map((e) => Song.fromMap(e)).toList();
  }

  Future<List<Song>> getFavorites() async {
    final db = await dbProvider.database;
    final result = await db.query('songs', where: 'isFavorite = ?', whereArgs: [1]);
    return result.map((e) => Song.fromMap(e)).toList();
  }

  Future<List<Song>> getRecentlyPlayed() async {
    final db = await dbProvider.database;
    final result = await db.query('songs', orderBy: 'lastPlayed DESC', limit: 20);
    return result.map((e) => Song.fromMap(e)).toList();
  }

  Future<List<Song>> getRecentlyAdded() async {
    final db = await dbProvider.database;
    final result = await db.query('songs', orderBy: 'dateAdded DESC', limit: 20);
    return result.map((e) => Song.fromMap(e)).toList();
  }

  Future<List<Song>> getMostPlayed() async {
    final db = await dbProvider.database;
    final result = await db.query('songs', orderBy: 'playCount DESC', limit: 20);
    return result.map((e) => Song.fromMap(e)).toList();
  }

  Future<int> updateSong(Song song) async {
    final db = await dbProvider.database;
    return await db.update('songs', song.toMap(), where: 'id = ?', whereArgs: [song.id]);
  }

  Future<int> deleteSong(int id) async {
    final db = await dbProvider.database;
    return await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markAsPlayed(int id) async {
    final db = await dbProvider.database;
    await db.execute('UPDATE songs SET playCount = playCount + 1, lastPlayed = ? WHERE id = ?',
        [DateTime.now().millisecondsSinceEpoch, id]);
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await dbProvider.database;
    await db.update('songs', {'isFavorite': isFavorite ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }
}
